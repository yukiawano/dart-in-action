import "dart:io";
import "dart:isolate";

// Requires command line argument, eg: c:\windows
// which is the folder to analyse
void main(List<String> args) {
  analyzeFileList(getFileList(args[0]));
}

analyzeFileList(fileList) {
  Isolate.spawn(getFileTypesEntryPoint, fileList);
  Isolate.spawn(getFileSizesEntryPoint, fileList);
  
  for (int i = 0; i < 1000000000; i++) {}
//  Map<String,int> typeCount = getFileTypes(fileList);
//  print(typeCount);
//  Map<String,int> totalSizes = getFileSizes(fileList);
//  print(totalSizes);
}

void getFileTypesEntryPoint(fileList) {
  Map<String,int> typeCount = getFileTypes(fileList);
  print(typeCount);
}

void getFileSizesEntryPoint(fileList) {
  Map<String,int> totalSizes = getFileSizes(fileList);
  print(totalSizes);
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