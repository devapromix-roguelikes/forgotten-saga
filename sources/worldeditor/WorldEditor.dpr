program WorldEditor;

uses
  Forms,
  Engine in '..\VCLEngine\Engine.pas',
  WorldEditor.MainForm in 'WorldEditor.MainForm.pas' {fMain},
  WorldEditor.Classes in 'WorldEditor.Classes.pas',
  ForgottenSaga.Classes in '..\ForgottenSaga.Classes.pas',
  ForgottenSaga.Scenes in '..\ForgottenSaga.Scenes.pas',
  Common.Map.Generator in '..\Common.Map.Generator.pas',
  ForgottenSaga.Entities in '..\ForgottenSaga.Entities.pas',
  WorldEditor.NewMapForm in 'WorldEditor.NewMapForm.pas' {fNew};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Forgotten Saga WorldEditor';
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfNew, fNew);
  Application.Run;

end.
