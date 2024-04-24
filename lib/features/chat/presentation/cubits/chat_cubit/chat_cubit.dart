import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/socket_service.dart';
import '../../../domain/use_cases/get_chat_use_case.dart';
import '../../../../../core/functions/show_snack_bar.dart';
import '../../../data/models/get_chat_response/message.dart';
import '../../../domain/use_cases/upload_chat_images_use_case.dart';
import '../../views/chat_view/widgets/chat_session_req_dialog.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(
    this._getChatUseCase,
    this._uploadChatImageUseCase,
  ) : super(ChatInitial());

  final GetChatUseCase _getChatUseCase;
  final UploadChatImagesUseCase _uploadChatImageUseCase;

  TextEditingController messageController = TextEditingController();

  TextEditingController pollQuestionController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  List<XFile> images = [];

  List<Message> messages = [];

  bool showMediaOptions = false;

  bool showPollOptions = false;

  void toggleMediaOptions() {
    if (userCache?.matchId == null) return;
    if (showPollOptions) showPollOptions = false;
    showMediaOptions = !showMediaOptions;
    emit(ChatMediaOptionsToggled());
  }

  void togglePollOptions() {
    if (userCache?.matchId == null) return;
    showPollOptions = !showPollOptions;
    emit(ChatPollOptionsToggled());
  }

  Future<void> getChat({
    int page = 1,
    int limit = 10,
  }) async {
    messages.clear();
    if (userCache?.matchId == null) {
      emit(GetChatFailure('You do not have a student partner yet!'));
      return;
    }
    emit(GetChatLoading());
    var result = await _getChatUseCase.call({
      'matchId': userCache?.matchId,
      'page': page,
      'limit': limit,
    });
    result.fold(
      (failure) => emit(GetChatFailure(failure.errMessage)),
      (response) {
        messages.addAll(response.messages ?? []);
        emit(GetChatSuccess(response.messages ?? []));
      },
    );
  }

  void sendMessage() {
    if (userCache?.matchId == null) return;
    if (messageController.text.trim().isNotEmpty) {
      SocketService.emit(
          eventName: 'sendMessage',
          data: {
            "messageType": 'text',
            "messageContent": messageController.text,
          },
          ack: (data) {
            if (data['success'] == true) {
              messageController.clear();
              messages.insert(
                  0,
                  Message(
                    id: data['data']['_id'],
                    messageContent: data['data']['messageContent'],
                    messageSender: data['data']['messageSender'],
                    messageType: data['data']['messageType'],
                    sentAt: DateTime.now(),
                  ));
              emit(GetChatSuccess(messages));
            } else {
              emit(GetChatFailure(data['message']));
            }
          });
    }
  }

  void listenOnNewMessage() {
    SocketService.on(
        eventName: 'receiveMessage',
        handler: (data) {
          messages.insert(
              0,
              Message(
                id: data['data']['_id'],
                messageContent: data['data']['messageContent'],
                messageSender: data['data']['messageSender'],
                messageType: data['data']['messageType'],
                sentAt: DateTime.now().toLocal(),
              ));
          emit(GetChatSuccess(messages));
        });
  }

  void deleteMessage(Message message) {
    SocketService.emit(
        eventName: 'deleteMessage',
        data: {"messageId": message.id},
        ack: (data) {
          if (data['success'] == true) {
            messages.remove(message);
            emit(GetChatSuccess(messages));
          } else {
            emit(GetChatFailure(data['message']));
          }
        });
  }

  void listenOnMessageDeleted() {
    if (userCache?.matchId == null) return;
    SocketService.on(
        eventName: 'messageDeleted',
        handler: (eventData) {
          messages.removeWhere((element) => element.id == eventData);
          emit(GetChatSuccess(messages));
        });
  }

  void startChatSession(BuildContext context) {
    SocketService.emit(
      eventName: 'startChatSession',
      data: {
        "chatSessionRequest": true,
        "sessionStartTime": DateTime.now().toLocal().toString(),
      },
      ack: (data) {
        if (data['success'] == true) {
          showCustomSnackBar(context, data['message']);
        } else {
          showCustomSnackBar(context, data['message']);
        }
      },
    );
  }

  void listenOnChatSessionRequest(BuildContext context) {
    if (userCache?.matchId == null) return;
    SocketService.on(
        eventName: 'newChatSessionRequest',
        handler: (eventData) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const ChatSessionReqDialog();
              });
        });
  }

  void replyToSessionRequest(bool accept, BuildContext context) {
    SocketService.emit(
      eventName: 'replyToSessionRequest',
      data: {"accept": accept},
      ack: (data) {
        if (data['success'] == true) {
          showCustomSnackBar(
            context,
            accept
                ? 'You accepted chat session request!'
                : 'You rejected chat session request!',
          );
        } else {
          showCustomSnackBar(context, data['message']);
        }
      },
    );
  }

  void listenOnReplyToSessionRequest(BuildContext context) {
    if (userCache?.matchId == null) return;
    SocketService.on(
        eventName: 'replyToRequest',
        handler: (eventData) {
          if (eventData['data']['accept'] == true) {
            showCustomSnackBar(
              context,
              'Chat session request accepted!',
            );
          } else {
            showCustomSnackBar(
              context,
              'Chat session request rejected!',
            );
          }
        });
  }

  void listenOnMatchRequestApproved() {
    if (userCache?.matchId == null) return;
    SocketService.on(
        eventName: 'matchRequestApproved',
        handler: (eventData) {
          Future.delayed(const Duration(seconds: 1), () async {
            await getChat();
          });
        });
  }

  Future<void> getLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    final List<XFile>? files = response.files;
    if (files != null) {
      images.addAll(files);
      emit(ChatMediaOptionsToggled());
    }
  }

  Future<void> pickImages() async {
    final List<XFile> files = await picker.pickMultiImage();
    if (files.isNotEmpty) {
      emit(UploadChatImagesLoading());
      var result = await _uploadChatImageUseCase.call(files);
      result.fold(
        (failure) => emit(UploadChatImagesFailure(failure.errMessage)),
        (response) {
          sendImages(response.links ?? []);
        },
      );
    }
  }

  void sendImages(List<dynamic> imageUrls) {
    SocketService.emit(
      eventName: 'sendMessage',
      data: {
        "messageType": 'media',
        "media": imageUrls,
      },
      ack: (data) {},
    );
  }

  void sendPoll() {
    SocketService.emit(
      eventName: 'sendMessage',
      data: {
        "messageType": 'poll',
        "pollQuestion": pollQuestionController.text,
      },
      ack: (data) {
        if (data['success'] == true) {
          messageController.clear();
          messages.insert(
            0,
            Message(
              id: data['data']['_id'],
              messageContent: data['data']['messageContent'],
              messageSender: data['data']['messageSender'],
              messageType: data['data']['messageType'],
              sentAt: DateTime.now(),
            ),
          );
          emit(GetChatSuccess(messages));
        } else {
          emit(GetChatFailure(data['message']));
        }
      },
    );
  }
}
