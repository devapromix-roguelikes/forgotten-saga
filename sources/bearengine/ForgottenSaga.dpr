﻿program ForgottenSaga;

uses
  SysUtils,
  Engine in 'Engine.pas',
  BearLibTerminal in 'BearLibTerminal.pas',
  ForgottenSaga.Classes in '..\ForgottenSaga.Classes.pas',
  ForgottenSaga.Entities in '..\ForgottenSaga.Entities.pas',
  ForgottenSaga.Scenes in '..\ForgottenSaga.Scenes.pas';

var
  Key: Word = 0;
  Tick: Integer = 0;

begin
  terminal_open();
  Saga := TSaga.Create(TMap.Size.Width + TUI.PanelWidth, TMap.Size.Height);
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
{
	  now := GetTickCount;
if now >= NextUpdateTime then begin
    Saga.Stages.Timer;
    NextUpdateTime := now + 60;
end;
}
      if (Tick > 59) then
      begin
        Saga.Stages.Timer;
        Tick := 0;
      end;
      // if (Key <> 0) then
      terminal_refresh();
      Inc(Tick);
      terminal_delay(1);
    until (Key = TK_CLOSE);
    terminal_close();
  finally
    Saga.Free;
  end;

end.
