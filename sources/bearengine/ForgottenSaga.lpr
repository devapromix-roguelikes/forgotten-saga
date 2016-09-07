program ForgottenSaga;

uses
  SysUtils,
  Interfaces,
  Engine in 'Engine.pas',
  BearLibTerminal in 'BearLibTerminal.pas',
  ForgottenSaga.Classes in '..\ForgottenSaga.Classes.pas',
  ForgottenSaga.Inv in '..\ForgottenSaga.Inv.pas',
  ForgottenSaga.Entities in '..\ForgottenSaga.Entities.pas',
  ForgottenSaga.Scenes in '..\ForgottenSaga.Scenes.pas',
  Common.Map.Generator in '..\Common.Map.Generator.pas';

var
  Key: word = 0;
  Tick: integer = 0;

begin
  terminal_open();
  Saga := TSaga.Create(MapWidth + UIPanelWidth, MapHeight);
  try
    Saga.Init;
    terminal_set(Format('window.title=%s', [__('Forgotten Saga')]));
    Saga.Stages.Render;
    terminal_refresh();
    repeat
      Saga.Stages.Render;
      Key := 0;
      if terminal_has_input() then
        Key := terminal_read();
      Saga.Stages.Update(Key);
      if (Tick > 59) then
      begin
        Saga.Stages.Timer;
        Tick := 0;
      end;
      terminal_refresh();
      Inc(Tick);
      terminal_delay(1);
    until (Key = TK_CLOSE);
    terminal_close();
  finally
    Saga.Free;
  end;

end.
