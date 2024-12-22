object dmMain: TdmMain
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object FDQuery1: TFDQuery
    Connection = Sqlite
    Left = 392
    Top = 56
  end
  object Sqlite: TFDConnection
    Params.Strings = (
      'ConnectionDef=SQLite_Demo')
    Connected = True
    LoginPrompt = False
    Left = 394
    Top = 114
  end
end
