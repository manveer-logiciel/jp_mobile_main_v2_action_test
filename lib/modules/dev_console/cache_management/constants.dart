class CacheManagementConstants {
  // Files to exclude from cache clearing
  static const List<String> excludedFileNames = [
    'CrashLog.txt',
    'JobProgress.db',
  ];
  
  // File extensions supported by the app (allowlist for upload clearing)
  // Based on FileHelper.getClassType() and supported file types
  static const List<String> supportedFileExtensions = [
    // Images
    'png',
    'jpg',
    'jpeg',
    'gif',
    'bmp',
    'webp',
    'jfif',
    
    // Documents
    'pdf',
    'doc',
    'docx',
    'txt',
    'rtf',
    'csv',
    
    // Spreadsheets
    'xls',
    'xlsx',
    
    // Presentations
    'ppt',
    'pptx',
    
    // Archives
    'zip',
    'rar',
    '7z',
    
    // Design/CAD files (from FileHelper.getClassType())
    'ai',   // Adobe Illustrator
    'psd',  // Photoshop
    'eps',  // Encapsulated PostScript
    'dxf',  // AutoCAD
    'dwg',  // AutoCAD Drawing
    'skp',  // SketchUp
    'ac5',  // AC5 files
    'ac6',  // AC6 files
    
    // Email files
    'eml',  // Email files
    
    // Media files
    'mp4',
    'mov',
    'avi',
    'mkv',
    'mp3',
    'wav',
    'aac',
    
    // Additional formats referenced in FileHelper
    've',   // VE files
    'esx',  // ESX files
    'sfz',  // SFZ files
    'sdr',  // SDR files
  ];
  
  // Folders to completely skip
  static const List<String> excludedFolders = [
    'flutter_assets',
    'flutter_assets/',
    '/flutter_assets',
    '/flutter_assets/',
  ];
  
  // Size conversion constants
  static const int bytesPerKB = 1024;
  static const int bytesPerMB = 1024 * 1024;
  static const int bytesPerGB = 1024 * 1024 * 1024;
} 