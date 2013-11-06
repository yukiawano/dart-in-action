import "dart:io";
import "dart:isolate";

// Requires one command line argument, eg: c:\windows
// which is the folder to analyse
void main(List<String> args) {
  analyzeFileList(getFileList(args[0]));
}

analyzeFileList(fileList) {
  var receivePort = new ReceivePort();
  var future = Isolate.spawn(getFileTypesEntryPoint, {"fileList":fileList, "sendPort":receivePort.sendPort});
  Isolate.spawn(getFileSizesEntryPoint, {"fileList":fileList, "sendPort":receivePort.sendPort});
  
  var replyCounter = 0;
  receivePort.listen((data) {
    print(data);
    
    replyCounter++;
    if(replyCounter >= 2) {
      receivePort.close();
    }
  });
}

void getFileTypesEntryPoint(message) {
  SendPort sendPort = message["sendPort"];
  List<String> fileList = message["fileList"];
  Map<String,int> typeCount = getFileTypes(fileList);
  sendPort.send(typeCount);
}

void getFileSizesEntryPoint(message) {
  SendPort sendPort = message["sendPort"];
  List<String> fileList = message["fileList"];
  Map<String,int> totalSizes = getFileSizes(fileList);
  sendPort.send(totalSizes);
}

Map<String,int> getFileTypes(fileList) {
  var result = new Map<String,int>();
  for (var filename in fileList) {
    var extension = getFileExtension(filename);
    if (result[extension] == null) {
      result[extension] = 1;
    }
    else {
      result[extension] ++;
    }
  }
  return result;
}

Map<String, int> getFileSizes(fileList) {
  var result = new Map<String,int>();
  
  for (var filename in fileList) {
    var file = new File(filename);
    var extension = getFileExtension(filename);
    if (result[extension] == null) {
     result[extension] = file.lengthSync(); 
    }
    else {
      result[extension] += file.lengthSync();
    }
    
  }
  
  return result;
}

String getFileExtension(String filename) {
  var extSeparator = filename.lastIndexOf('.');
  extSeparator = extSeparator == -1 ? 0 : extSeparator;
  return filename.substring(extSeparator, filename.length).toUpperCase();  
}

List<String> getFileList(String folderPath) {
  var directory = new Directory(folderPath);
  
  if(directory.existsSync()) {
    return directory.listSync()
        .map((FileSystemEntity e) => e.path)
          .where((String e) => FileSystemEntity.isFileSync(e))
            .toList();
  } else {
    return null;
  }
}