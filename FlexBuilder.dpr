program FlexBuilder;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMainFlex in 'uMainFlex.pas' {frmMain},
  FMX.UIFlexBuilder in 'FMX.UIFlexBuilder.pas',
  dMain in 'dMain.pas' {dmMain: TDataModule},
  DC.Firedac.VersionControl in 'DC.Units\DC.Firedac.VersionControl.pas',
  DC.Logger in 'DC.Units\DC.Logger.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
