﻿unit Engine;

interface

uses
  Types;

{$REGION ' Keyboard scancodes '}

const
  TK_A = $04;
  TK_B = $05;
  TK_C = $06;
  TK_D = $07;
  TK_E = $08;
  TK_F = $09;
  TK_G = $0A;
  TK_H = $0B;
  TK_I = $0C;
  TK_J = $0D;
  TK_K = $0E;
  TK_L = $0F;
  TK_M = $10;
  TK_N = $11;
  TK_O = $12;
  TK_P = $13;
  TK_Q = $14;
  TK_R = $15;
  TK_S = $16;
  TK_T = $17;
  TK_U = $18;
  TK_V = $19;
  TK_W = $1A;
  TK_X = $1B;
  TK_Y = $1C;
  TK_Z = $1D;
  TK_1 = $1E;
  TK_2 = $1F;
  TK_3 = $20;
  TK_4 = $21;
  TK_5 = $22;
  TK_6 = $23;
  TK_7 = $24;
  TK_8 = $25;
  TK_9 = $26;
  TK_0 = $27;
  TK_RETURN = $28;
  TK_ENTER = $28;
  TK_ESCAPE = $29;
  TK_BACKSPACE = $2A;
  TK_TAB = $2B;
  TK_SPACE = $2C;
  TK_MINUS = $2D;
  TK_EQUALS = $2E;
  TK_LBRACKET = $2F;
  TK_RBRACKET = $30;
  TK_BACKSLASH = $31;
  TK_SEMICOLON = $33;
  TK_APOSTROPHE = $34;
  TK_GRAVE = $35;
  TK_COMMA = $36;
  TK_PERIOD = $37;
  TK_SLASH = $38;
  TK_F1 = $3A;
  TK_F2 = $3B;
  TK_F3 = $3C;
  TK_F4 = $3D;
  TK_F5 = $3E;
  TK_F6 = $3F;
  TK_F7 = $40;
  TK_F8 = $41;
  TK_F9 = $42;
  TK_F10 = $43;
  TK_F11 = $44;
  TK_F12 = $45;
  TK_PAUSE = $48;
  TK_INSERT = $49;
  TK_HOME = $4A;
  TK_PAGEUP = $4B;
  TK_DELETE = $4C;
  TK_END = $4D;
  TK_PAGEDOWN = $4E;
  TK_RIGHT = $4F;
  TK_LEFT = $50;
  TK_DOWN = $51;
  TK_UP = $52;
  TK_KP_DIVIDE = $54;
  TK_KP_MULTIPLY = $55;
  TK_KP_MINUS = $56;
  TK_KP_PLUS = $57;
  TK_KP_ENTER = $58;
  TK_KP_1 = $59;
  TK_KP_2 = $5A;
  TK_KP_3 = $5B;
  TK_KP_4 = $5C;
  TK_KP_5 = $5D;
  TK_KP_6 = $5E;
  TK_KP_7 = $5F;
  TK_KP_8 = $60;
  TK_KP_9 = $61;
  TK_KP_0 = $62;
  TK_KP_PERIOD = $63;
  TK_SHIFT = $70;
  TK_CONTROL = $71;
  TK_ALT = $72;

{$ENDREGION ' Keyboard scancodes '}
{$REGION ' TEngine '}

type
  TAlign = (aLeft, aCenter, aRight);

type
  TSize = record
    Width: Integer;
    Height: Integer;
  end;

type
  TEngine = class(TObject)
  private
    FWindow: TSize;
    FChar: TSize;
  public
    procedure Clear;
    constructor Create(AWidth, AHeight: Integer);
    destructor Destroy; override;
    procedure Print(X, Y: Integer; S: string;
      Align: TAlign = aLeft); overload;
    function Print(S: string; R: TRect): Integer; overload;
    procedure ForegroundColor(Color: Integer);
    procedure BackgroundColor(Color: Integer);
    function LightColor(Color: Integer; Percent: Byte): Integer;
    function DarkColor(Color: Integer; Percent: Byte): Integer;
    function GetColor(Color: Integer): Cardinal;
    property Window: TSize read FWindow write FWindow;
    property Char: TSize read FChar write FChar;
    function GetTextLength(Text: string): Integer;
    procedure Close;
  end;

{$ENDREGION ' TEngine '}

const
  clClear = -1;
  kcBegin = '{';
  kcEnd = '}';

implementation

uses
  BearLibTerminal,
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LazUTF8,
{$ENDIF}
  Classes, SysUtils;

{$REGION ' TEngine '}

constructor TEngine.Create(AWidth, AHeight: Integer);
begin
  Randomize;
  FWindow.Width := AWidth;
  FWindow.Height := AHeight;
  terminal_set(Format('window: size=%dx%d, icon=%s', [AWidth, AHeight,
    'resources\icon.ico']));
  FChar.Width := terminal_state(TK_CELL_WIDTH);
  FChar.Height := terminal_state(TK_CELL_HEIGHT);
end;

destructor TEngine.Destroy;
begin
  inherited;
end;

procedure TEngine.ForegroundColor(Color: Integer);
begin
  terminal_color(GetColor(Color));
end;

procedure TEngine.BackgroundColor(Color: Integer);
begin
  case Color of
    clClear:
      terminal_bkcolor(0);
  else
    terminal_bkcolor(GetColor(Color));
  end;
end;

procedure TEngine.Clear;
begin
  terminal_clear();
end;

procedure TEngine.Close;
begin
  terminal_close();
end;

procedure TEngine.Print(X, Y: Integer; S: string; Align: TAlign = aLeft);
begin
  case Align of
    aLeft:
      terminal_print(X, Y, S);
    aCenter:
      terminal_print((Window.Width div 2) -
        (GetTextLength(S) div 2), Y, S);
    aRight:
      terminal_print(Window.Width - GetTextLength(S), Y, S);
  end;
end;

function TEngine.Print(S: string; R: TRect): Integer;
begin
  Result := terminal_print(R.Left, R.Top,
    Format('[bbox=%dx%d][align=left-top]%s',
    [R.Right, R.Bottom, S]));
end;

function TEngine.DarkColor(Color: Integer; Percent: Byte): Integer;
var
  R, G, B: Byte;
  C: Integer;
begin
  if Color < 0 then
    C := GetSysColor(Color and $000000FF)
  else
    C := Color;
  R := GetRValue(C);
  G := GetGValue(C);
  B := GetBValue(C);
  R := R - MulDiv(R, Percent, 100);
  G := G - MulDiv(G, Percent, 100);
  B := B - MulDiv(B, Percent, 100);
  Result := RGB(R, G, B);
end;

function TEngine.LightColor(Color: Integer; Percent: Byte): Integer;
var
  R, G, B: Byte;
  C: Integer;
begin
  if Color < 0 then
    C := GetSysColor(Color and $000000FF)
  else
    C := Color;
  R := GetRValue(C);
  G := GetGValue(C);
  B := GetBValue(C);
  R := R + MulDiv(255 - R, Percent, 100);
  G := G + MulDiv(255 - G, Percent, 100);
  B := B + MulDiv(255 - B, Percent, 100);
  Result := RGB(R, G, B);
end;

function TEngine.GetColor(Color: Integer): Cardinal;
var
  R, G, B: Byte;
  C: Integer;
begin
  if Color < 0 then
    C := GetSysColor(Color and $000000FF)
  else
    C := Color;
  R := GetRValue(C);
  G := GetGValue(C);
  B := GetBValue(C);
  Result := color_from_argb(255, R, G, B);
end;

function TEngine.GetTextLength(Text: string): Integer;
begin
{$IFNDEF FPC}
  Result := Length(Text);
{$ELSE}
  Result := UTF8Length(Text);
{$ENDIF}
end;

{$ENDREGION ' TEngine '}

end.
