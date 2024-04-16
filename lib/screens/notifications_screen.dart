import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safe_house/models/notification.dart';
import 'package:safe_house/repositories/notifications_repository.dart';
import 'package:safe_house/widgets/loading_view.dart';
import 'package:safe_house/widgets/page_error.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NotificationRepository().fetchNotification(),
      builder: (context, AsyncSnapshot<List<NotificationModel>> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Адрес',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        width: 1,
                        color: Colors.white,
                      ),
                      const Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Статус',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        width: 1,
                        color: Colors.white,
                      ),
                      const Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Дата',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.white,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: snapshot.data?.length ?? 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 1,
                      color: const Color.fromRGBO(255, 255, 255, 0.5),
                    );
                  },
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.data![index].house?.address ?? '-',
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Container(
                              height: double.infinity,
                              width: 1,
                              color: const Color.fromRGBO(255, 255, 255, 0.5)),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${snapshot.data![index].message}',
                              ),
                            ),
                          ),
                          Container(
                            height: double.infinity,
                            width: 1,
                            color: const Color.fromRGBO(255, 255, 255, 0.5),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(DateFormat('dd.MM.yyyy').format(
                                  DateTime.parse(
                                      "${snapshot.data![index].created_at}"))),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return CustomPageError();
        }
        return CustomPageLoader();
      },
    );
  }
}
