import 'dart:io';
import 'package:deckinspectors/src/ui/pdfviewer.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ReportsPage(); //create state
  }
}

class _ReportsPage extends State<ReportsPage> {
  final List<FileSystemEntity> _folders = [];

  void getFiles() async {
    //asyn function to get list of files
    Directory? directory = await getApplicationDocumentsDirectory();

    await for (FileSystemEntity entity
        in directory.list(recursive: true, followLinks: false)) {
      FileSystemEntityType type = await FileSystemEntity.type(entity.path);
      if (type == FileSystemEntityType.file &&
          (entity.path.endsWith('.pdf') || entity.path.endsWith('.docx'))) {
        setState(() {
          _folders.add(entity);
        });
      }
    }
  }

  @override
  void initState() {
    getFiles(); //call getFiles() function on initial state.
    super.initState();
  }

  String sizeInKB = '0';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Downloaded Reports',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: _folders.isEmpty
            ? const Text("No reports downloaded")
            : ListView.builder(
                //if file/folder list is grabbed, then show here
                itemCount: _folders.length,
                itemBuilder: (context, index) {
                  if (_folders[index] is File) {
                    File(_folders[index].path).length().then((value) {
                      setState(() {
                        sizeInKB = (value / 1000000).toStringAsPrecision(6);
                      });
                    });
                  }
                  return Card(
                      child: ListTile(
                    title: Text(_folders[index].path.split('/').last),
                    leading: const Icon(Icons.picture_as_pdf),
                    subtitle: Text('$sizeInKB MB'),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: Colors.redAccent,
                    ),
                    onLongPress: () {
                      _onShareData(
                          context,
                          _folders[index].path.split('/').last,
                          _folders[index].path.toString());
                    },
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PDFViewerPage(_folders[index].path.toString());
                        //open viewPDF page on click
                      }));
                    },
                  ));
                },
              ));
  }

  _onShareData(
      BuildContext context, String fileName, String pdfFilePath) async {
    //final box = context.findRenderObject() as RenderBox?;
    final files = <XFile>[];
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    files.add(XFile(pdfFilePath, name: fileName));
    var shareResult = await Share.shareXFiles(files, subject: 'Project Report');
    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  }

  SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }
}
