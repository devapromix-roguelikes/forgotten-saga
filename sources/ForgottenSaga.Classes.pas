﻿unit ForgottenSaga.Classes;

interface

uses Classes, Types, Engine, ForgottenSaga.Scenes, ForgottenSaga.Entities;

{$REGION 'Utils'}
function __(S: string): string;

type
  TUtils = class(TObject)
    class function Percent(N, P: Integer): Integer;
    class procedure Box(); overload;
    class procedure Box(const S: string); overload;
    class procedure Box(const I: Integer); overload;
    class function BarWidth(CX, MX, WX: Integer): Integer;
    class function Clamp(Value, AMin, AMax: Integer;
      Flag: Boolean = True): Integer;
    class function ExplodeString(const Separator, Source: string): TStringlist;
    class function GetStr(const Separator: Char; S: string; I: Integer): string;
    class function RandStr(const Separator: Char; S: string): string;
    class function GetPath(SubDir: string = ''): string;
  end;

{$ENDREGION 'Utils'}
{$REGION 'TUI'}

type
  TUI = class(TObject)
  public const
    PanelWidth = 40;
  private
    FEngine: TEngine;
  public
    constructor Create(AEngine: TEngine);
    procedure DrawTitle(Y: Word; Text: string);
    procedure DrawChar(X, Y: Integer; Symbol: System.Char;
      ForegroundColor, BackgroundColor: Integer);
    procedure DrawKey(X, Y: Integer; Caption: string; Key: string;
      Active: Boolean = True); overload;
    procedure DrawKey(X, Y: Integer; Caption: string; Key: string;
      Align: TAlign; Active: Boolean = True); overload;
    property Engine: TEngine read FEngine write FEngine;
  end;

{$ENDREGION 'TUI'}

type
  TVars = class(TObject)
  private
    FID: TStringlist;
    FValue: TStringlist;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Count: Integer;
    procedure Empty(const AVar: string);
    function Has(const AVar: string): Boolean;
    procedure SaveToFile(const FileName: string);
    procedure LoadFromFile(const FileName: string);
    function GetStr(const AVar: string): string;
    procedure SetStr(const AVar, AValue: string);
    function GetInt(const AVar: string): Integer;
    procedure SetInt(const AVar: string; const AValue: Integer);
  end;

type
  TScript = class(TObject)
  private
    FIsNext: Boolean;
    FIsIf: Boolean;
    FList: TStringlist;
    FCloseTag: string;
    FVars: TVars;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromFile(const FileName: string);
    function GetSource(const ID: string): string;
    procedure Exec(const ID: string);
    procedure Next(const ID: string);
    procedure Run(const Code: string);
    procedure RunCode(const Code: string);
    property CloseTag: string read FCloseTag write FCloseTag;
    property Vars: TVars read FVars write FVars;
  end;

type
  TLanguage = class(TObject)
  private
    FID: TStringlist;
    FValue: TStringlist;
    FCurrent: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromFile(FileName: string);
    function Get(S: string): string;
    property Current: string read FCurrent write FCurrent;
  end;

{$REGION 'Colors'}

type
  TColors = class(TObject)
  public type
    TColorsEnum = (ceBlack, ceBlue, ceGreen, ceCyan, ceRed, ceMagenta, ceBrown,
      ceLGray, ceDGray, ceLBlue, ceLGreen, ceLCyan, ceLRed, ceLMagenta,
      ceYellow, ceWhite);
  private const
    ColorsStr: array [TColorsEnum] of string = ('BLACK', 'BLUE', 'GREEN',
      'CYAN', 'RED', 'MAGENTA', 'BROWN', 'LGRAY', 'DGRAY', 'LBLUE', 'LGREEN',
      'LCYAN', 'LRED', 'LMAGENTA', 'YELLOW', 'WHITE');
  public
  var
    clNotification: Integer;
    clTitle: Integer;
    clHotKey: Integer;
    clButton: Integer;
    clSplText: Integer;
    clGoldText: Integer;
    clAlertText: Integer;
    clMenuAct: Integer;
    clMenuDef: Integer;
    clCursor: Integer;
  private
    FColors: array [TColorsEnum] of Integer;
    procedure SetColors;
  public
    procedure LoadFromFile(FileName: string);
    function GetColor(Color: TColorsEnum): Integer; overload;
    function GetColor(Color: string): Integer; overload;
  end;

{$ENDREGION 'Colors'}

type
  TConfig = class(TObject)
  private

  public
    procedure LoadFromFile(FileName: string);
  end;

type
  TNotification = class(TObject)
  private
    FMessage: string;
    FDuration: Byte;
    FCounter: Byte;
  public
    constructor Create(Duration: Byte = 5);
    procedure Add(S: string);
    procedure Render(Left, Top: Word);
    property Duration: Byte read FDuration write FDuration;
    property Counter: Byte read FCounter write FCounter;
    procedure Dec;
  end;

type
  TWorld = class(TObject)
  private
    FMaps: array of TMap;
    FCreatures: array of TCreatures;
    FItems: array of TItems;
    FEngine: TEngine;
  public
    constructor Create;
    destructor Destroy; override;
    function GetMap(I: Byte): TMap;
    function GetMapCreatures(I: Byte): TCreatures;
    function GetMapItems(I: Byte): TItems;
    function CurrentMap: TMap;
    function GoLoc(Dir: TMap.TDir): Boolean;
    function CurrentCreatures: TCreatures;
    function CurrentItems: TItems;
    function Count: Byte;
    function FileName(Dir: string; ID: Byte; Ext: string): string;
    procedure SaveToDir(Dir: string);
    procedure LoadFromDir(Dir: string);
    procedure Gen(I: Byte);
    property Engine: TEngine read FEngine write FEngine;
  end;

type
  TLog = class(TObject)
  private
    FLogStr: string;
    FLen: Word;
  public
    constructor Create(Len: Word);
    procedure Clear;
    procedure ClearTags;
    procedure Add(Text: string; Flag: Boolean = True);
    function Get: string;
    procedure LoadFromFile(FileName: string);
    procedure SaveToFile(FileName: string);
    procedure Render(Left, Top, Width: Word);
  end;

type
  TRecs = class(TObject)
  private
    FFileName: string;
    procedure Add(Slot: Byte);
  public
    constructor Create(FileName: string);
    procedure Load();
    procedure Save();
  end;

type
  TBattle = class(TObject)
  private
    FID: Integer;
    function EnemyName(): string;
  public
    procedure EnemyMove();
    procedure Finish();
    procedure PlayerMove();
    procedure Start(ID: Byte);
    constructor Create;
    destructor Destroy; override;
    property ID: Integer read FID write FID;
  end;

type
  TQuest = class(TObject)
  private
    FList: TStringlist;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Get(Slot, N: Byte): string;
    procedure Add(Slot: Byte; Data: string);
    procedure LoadFromFile(FileName: string);
    procedure SaveToFile(FileName: string);
  end;

{$REGION 'TSaga'}

type
  TSaga = class(TObject)
  public type
    TRaceEnum = (rcGoblin, rcOrc, rcTroll);
    TLogEnum = (lgGame, lgIntro, lgDialog, lgBattle, lgQuest);
  public const
    RaceName: array [TRaceEnum] of string =
      ('Avgu,Leo,Tan,Sho,Penr,Lok,Gron,Lar,Midr|sin,neg,zar,kar,tun,rel,bal,rin,kon|or,fin,shog,tal,rod,pin,ol,kan,on',
      'Had,Rod,Shag,Dor,Lid,Tar,Kreg,Bron,Shung|Garum,Turum,Ur,Utak,Udoom,Ud,Urak,Doon,Vuug|Kat,Shak,Gir,Bood,Dreg,Din,Grok,Rig,Sadr',
      'Blind,Glad,Proud,Sharp-sighted,Powerful,Dancer,Guarding,Thunderous,Night|Wolfhound,Wood-goblin,Destroyer,Crusher,Pathfinder,Astrologer,Bootes,Caretaker,Befouler');
  private
    FList: TStringlist;
    FPlayer: TPlayer;
    FStages: TStages;
    FWorld: TWorld;
    FBattle: TBattle;
    FEngine: TEngine;
    FTiles: TTiles;
    FQuest: TQuest;
    FRecs: TRecs;
    FLg: TLanguage;
    FTUI: TUI;
    FColors: TColors;
    FNotification: TNotification;
    FLog: array [TLogEnum] of TLog;
    FRace: array [TRaceEnum] of TRace;
    FDialog: TScript;
  protected
    function GetLog(I: TLogEnum): TLog;
    procedure SetLog(I: TLogEnum; const Value: TLog);
    function GetRace(I: TRaceEnum): TRace;
    procedure SetRace(I: TRaceEnum; const Value: TRace);
  public
    constructor Create(AWidth, AHeight: Integer);
    destructor Destroy; override;
    procedure New();
    procedure Init;
    procedure LoadSlots;
    procedure ClearLogs;
    procedure ClearSlots;
    procedure AddRace(ID: TRaceEnum; Name: string; Life, Mana: Word;
      Pos: TPoint; Map: Byte; Color: Integer);
    function GetSlotData(Slot: Byte): string;
    function GetSlotPath(Slot: Byte): string;
    function LoadFromSlot(Slot: Byte): Boolean;
    procedure SaveToSlot(Slot: Byte);
    property Player: TPlayer read FPlayer write FPlayer;
    property Stages: TStages read FStages write FStages;
    property World: TWorld read FWorld write FWorld;
    property Battle: TBattle read FBattle write FBattle;
    property Engine: TEngine read FEngine write FEngine;
    property Tiles: TTiles read FTiles write FTiles;
    property Quest: TQuest read FQuest write FQuest;
    property Log[I: TLogEnum]: TLog read GetLog write SetLog;
    property Race[I: TRaceEnum]: TRace read GetRace write SetRace;
    property Notification: TNotification read FNotification write FNotification;
    property List: TStringlist read FList write FList;
    property Recs: TRecs read FRecs write FRecs;
    property Lg: TLanguage read FLg write FLg;
    property UI: TUI read FTUI write FTUI;
    property Colors: TColors read FColors write FColors;
    property Dialog: TScript read FDialog write FDialog;
  end;

var
  Saga: TSaga;

{$ENDREGION 'TSaga'}

implementation

uses Math, SysUtils, Dialogs, IniFiles;

{$REGION 'Utils'}

function __(S: string): string;
begin
  Result := '';
  if (S = '') then
    Exit;
  Result := Saga.Lg.Get(S);
end;

class function TUtils.Percent(N, P: Integer): Integer;
begin
  Result := N * P div 100;
end;

class function TUtils.RandStr(const Separator: Char; S: string): string;
var
  SL: TStringlist;
begin
  SL := TUtils.ExplodeString(Separator, S);
  Result := Trim(SL[Math.RandomRange(0, SL.Count)]);
end;

class procedure TUtils.Box();
begin
  ShowMessage('');
end;

class procedure TUtils.Box(const S: string);
begin
  ShowMessage(S);
end;

class function TUtils.BarWidth(CX, MX, WX: Integer): Integer;
begin
  Result := Round(CX / MX * WX);
end;

class procedure TUtils.Box(const I: Integer);
begin
  ShowMessage(Format('%d', [I]));
end;

class function TUtils.Clamp(Value, AMin, AMax: Integer; Flag: Boolean): Integer;
begin
  Result := Value;
  if (Result < AMin) then
    if Flag then
      Result := AMin
    else
      Result := AMax;
  if (Result > AMax) then
    if Flag then
      Result := AMax
    else
      Result := AMin;
end;

class function TUtils.ExplodeString(const Separator, Source: string)
  : TStringlist;
begin
  Result := TStringlist.Create();
  Result.Text := StringReplace(Source, Separator, #13, [rfReplaceAll]);
end;

class function TUtils.GetPath(SubDir: string): string;
begin
  Result := ExtractFilePath(ParamStr(0));
  Result := IncludeTrailingPathDelimiter(Result + SubDir);
end;

class function TUtils.GetStr(const Separator: Char; S: string;
  I: Integer): string;
var
  SL: TStringlist;
begin
  SL := TUtils.ExplodeString(Separator, S);
  Result := Trim(SL[I]);
end;

{$ENDREGION 'Utils'}
{$REGION 'TWorld'}

function TWorld.Count: Byte;
begin
  Result := Length(FMaps);
end;

constructor TWorld.Create;
var
  I, C: Integer;
  S: string;
  F: TIniFile;
begin
  F := TIniFile.Create(TUtils.GetPath('resources') + 'world.ini');
  try
    S := 'Main';
    C := F.ReadInteger(S, 'Count', 0);
    SetLength(FMaps, C);
    SetLength(FCreatures, C);
    SetLength(FItems, C);
    for I := 0 to Count - 1 do
    begin
      S := Format('%d', [I]);
      FMaps[I] := TMap.Create;
      FCreatures[I] := TCreatures.Create;
      FItems[I] := TItems.Create;
      FMaps[I].Name := F.ReadString(S, 'Name', '');
      FMaps[I].FileName := F.ReadString(S, 'FileName', '');
      FMaps[I].Map[drLeft] := F.ReadInteger(S, 'Left', -1);
      FMaps[I].Map[drUp] := F.ReadInteger(S, 'Up', -1);
      FMaps[I].Map[drRight] := F.ReadInteger(S, 'Right', -1);
      FMaps[I].Map[drDown] := F.ReadInteger(S, 'Down', -1);
      FMaps[I].Map[drTop] := F.ReadInteger(S, 'Top', -1);
      FMaps[I].Map[drBottom] := F.ReadInteger(S, 'Bottom', -1);
    end;
  finally
    F.Free;
  end;
end;

function TWorld.CurrentCreatures: TCreatures;
begin
  Result := FCreatures[Saga.Player.Map];
end;

function TWorld.CurrentMap: TMap;
begin
  Result := FMaps[Saga.Player.Map];
end;

function TWorld.CurrentItems: TItems;
begin
  Result := FItems[Saga.Player.Map];
end;

destructor TWorld.Destroy;
var
  I: Byte;
begin
  for I := 0 to Count - 1 do
  begin
    FMaps[I].Free;
    FCreatures[I].Free;
    FItems[I].Free;
  end;
  SetLength(FMaps, 0);
  SetLength(FCreatures, 0);
  SetLength(FItems, 0);
  inherited;
end;

function TWorld.GetMap(I: Byte): TMap;
begin
  Result := FMaps[I];
end;

function TWorld.GetMapCreatures(I: Byte): TCreatures;
begin
  Result := FCreatures[I];
end;

function TWorld.GetMapItems(I: Byte): TItems;
begin
  Result := FItems[I];
end;

function TWorld.FileName(Dir: string; ID: Byte; Ext: string): string;
begin
  Result := Dir + FMaps[ID].FileName + Ext;
end;

procedure TWorld.LoadFromDir(Dir: string);
var
  I: Byte;
begin
  for I := 0 to Count - 1 do
  begin
    FMaps[I].LoadFromFile(FileName(Dir, I, '.map'));
    FCreatures[I].LoadFromFile(FileName(Dir, I, '.crt'));
    FItems[I].LoadFromFile(FileName(Dir, I, '.itm'));
  end;
end;

procedure TWorld.SaveToDir(Dir: string);
var
  I: Byte;
begin
  for I := 0 to Count - 1 do
  begin
    FMaps[I].SaveToFile(FileName(Dir, I, '.map'));
    FCreatures[I].SaveToFile(FileName(Dir, I, '.crt'));
    FItems[I].SaveToFile(FileName(Dir, I, '.itm'));
  end;
end;

function TWorld.GoLoc(Dir: TMap.TDir): Boolean;
var
  ID: Integer;
begin
  Result := False;
  ID := Saga.World.CurrentMap.Map[Dir];
  if (ID > -1) then
  begin
    Saga.Log[lgGame].Add(Format(__('You walked in <RED>%s.</>'),
      [Saga.World.GetMap(ID).Name]));
    Saga.Player.Map := ID;
    Result := True;
  end;
end;

procedure TWorld.Gen(I: Byte);
begin
  FMaps[I].Gen;
  FMaps[I].SaveToFile(TUtils.GetPath('resources') + '0.map');
end;

{$ENDREGION 'TWorld'}
{$REGION 'TSaga'}

constructor TSaga.Create(AWidth, AHeight: Integer);
const
  LogLen: array [TLogEnum] of Integer = (500, 1000, 1000, 1400, 1600);
var
  I: Byte;
  L: TLogEnum;
  R: TRaceEnum;
begin
  FEngine := TEngine.Create(AWidth, AHeight);
  FTUI := TUI.Create(FEngine);
  FList := TStringlist.Create;
  ClearSlots;
  ForceDirectories(TUtils.GetPath('save'));
  for I := 0 to 9 do
    ForceDirectories(GetSlotPath(I));

  for L := Low(TLogEnum) to High(TLogEnum) do
    Self.Log[L] := TLog.Create(LogLen[L]);

  Lg := TLanguage.Create;

  FPlayer := TPlayer.Create;
  FStages := TStages.Create;
  FWorld := TWorld.Create;

  for R := Low(TRaceEnum) to High(TRaceEnum) do
    Race[R] := TRace.Create;

  FColors := TColors.Create;

  FBattle := TBattle.Create;
  FQuest := TQuest.Create;
  FTiles := TTiles.Create;
  FDialog := TScript.Create;

  FNotification := TNotification.Create();
  FRecs := TRecs.Create(TUtils.GetPath('save') + 'records.txt');

  Stages.SetStage(stMainMenu);
end;

procedure TSaga.Init;
var
  S: TStringlist;
  F: string;
  I: Integer;
begin
  // Load intro
  S := TStringlist.Create;
  try
    F := TUtils.GetPath('resources') + Lg.Current + '.intro.txt';
    if (FileExists(F)) then
    begin
      S.LoadFromFile(F{$IFNDEF FPC}, TEncoding.UTF8{$ENDIF});
      for I := 0 to S.Count - 1 do
        Log[lgIntro].Add(__(S[I]), False);
    end;
  finally
    S.Free;
  end;

  // Localization
  Lg.Clear;
  Lg.LoadFromFile(TUtils.GetPath('resources') + Lg.Current + '.txt');
  Lg.LoadFromFile(TUtils.GetPath('resources') + Lg.Current + '.names.txt');
  Lg.LoadFromFile(TUtils.GetPath('resources') + Lg.Current + '.world.txt');
  Lg.LoadFromFile(TUtils.GetPath('resources') + Lg.Current + '.terrain.txt');
  Lg.LoadFromFile(TUtils.GetPath('resources') + Lg.Current + '.objects.txt');

  // Colors
  Colors.LoadFromFile(TUtils.GetPath('resources') + 'colors.ini');

  // Tiles
  Tiles.LoadFromFile(TUtils.GetPath('resources') + 'terrain.ini');
  // Tiles.LoadFromFile(GetPath('resources') + 'objects.ini');

  // Races
  AddRace(rcGoblin, __('Goblin'), 90, 100, Point(40, 20), 0, $00882295);
  AddRace(rcOrc, __('Orc'), 120, 100, Point(40, 20), 0, $0063C3C6);
  AddRace(rcTroll, __('Troll'), 150, 100, Point(40, 20), 0, $00664567);
end;

destructor TSaga.Destroy;
var
  R: TRaceEnum;
  L: TLogEnum;
begin
  for R := Low(TRaceEnum) to High(TRaceEnum) do
    Race[R].Free;
  for L := Low(TLogEnum) to High(TLogEnum) do
    Self.Log[L].Free;
  FNotification.Free;
  FLg.Free;
  FTUI.Free;
  FColors.Free;
  FRecs.Free;
  FList.Free;
  FPlayer.Free;
  FStages.Free;
  FWorld.Free;
  FBattle.Free;
  FEngine.Free;
  FDialog.Free;
  FTiles.Free;
  FQuest.Free;
  inherited;
end;

procedure TSaga.ClearSlots;
var
  I: Byte;
begin
  FList.Clear;
  for I := 0 to 9 do
    FList.Append('');
end;

function TSaga.GetSlotPath(Slot: Byte): string;
begin
  Result := IncludeTrailingPathDelimiter
    (Format('%s%d', [TUtils.GetPath('save'), Slot]));
end;

function TSaga.GetLog(I: TLogEnum): TLog;
begin
  Result := FLog[I];
end;

function TSaga.GetRace(I: TRaceEnum): TRace;
begin
  Result := FRace[I];
end;

function TSaga.GetSlotData(Slot: Byte): string;
begin
  Result := FList[Slot];
end;

procedure TSaga.New;
begin
  Player.Clear;
  Saga.ClearLogs;
  World.LoadFromDir(TUtils.GetPath('resources'));
  // World.Gen(0); // Пока вместо редактора
  Stages.SetStage(stGame);
  Saga.Notification.Add('Создан новый мир');
end;

function TSaga.LoadFromSlot(Slot: Byte): Boolean;
begin
  Result := False;
  if not FileExists(GetSlotPath(Slot) + 'game.log') then
    Exit;
  Player.LoadFromFile(GetSlotPath(Slot) + 'player.crt');
  Log[lgGame].LoadFromFile(GetSlotPath(Slot) + 'game.log');
  Quest.LoadFromFile(GetSlotPath(Slot) + 'quest.log');
  World.LoadFromDir(GetSlotPath(Slot));
  Dialog.Vars.LoadFromFile(GetSlotPath(Slot) + 'vars.txt');
  Result := True;
  if Result then
    Saga.Notification.Add('Игра успешно загружена');
end;

procedure TSaga.SaveToSlot(Slot: Byte);
begin
  Player.SaveToFile(GetSlotPath(Slot) + 'player.crt');
  Log[lgGame].SaveToFile(GetSlotPath(Slot) + 'game.log');
  Self.Quest.SaveToFile(GetSlotPath(Slot) + 'quest.log');
  World.SaveToDir(GetSlotPath(Slot));
  Dialog.Vars.SaveToFile(GetSlotPath(Slot) + 'vars.txt');
  FList[Slot] := Format('%s %s - %s', [DateTimeToStr(Now), Player.GetFullName,
    World.GetMap(Player.Map).Name]);
  FList.SaveToFile(TUtils.GetPath('save') + 'list.txt'{$IFNDEF FPC},
    TEncoding.UTF8{$ENDIF});
  Saga.Notification.Add('Игра успешно сохранена');
end;

procedure TSaga.SetLog(I: TLogEnum; const Value: TLog);
begin
  FLog[I] := Value;
end;

procedure TSaga.SetRace(I: TRaceEnum; const Value: TRace);
begin
  FRace[I] := Value;
end;

procedure TSaga.AddRace(ID: TRaceEnum; Name: string; Life, Mana: Word;
  Pos: TPoint; Map: Byte; Color: Integer);
begin
  Race[ID].Color := Color;
  Race[ID].Name := Name;
  Race[ID].Life := Life;
  Race[ID].Mana := Mana;
  Race[ID].Pos := Pos;
  Race[ID].Map := Map;
end;

procedure TSaga.LoadSlots;
var
  F: string;
begin
  ClearSlots;
  F := TUtils.GetPath('save') + 'list.txt';
  if FileExists(F) then
    FList.LoadFromFile(F{$IFNDEF FPC}, TEncoding.UTF8{$ENDIF});
end;

procedure TSaga.ClearLogs;
begin
  Saga.Quest.Clear;
  Saga.Log[lgGame].Clear;
end;

{$ENDREGION 'TSaga'}
{$REGION 'TLog'}

procedure TLog.Add(Text: string; Flag: Boolean = True);
begin
  Text := Trim(Text);
  if (Text = '') then
    Exit;
  ClearTags;
  if Flag then
    FLogStr := Text + ' ' + FLogStr
  else
    FLogStr := FLogStr + ' ' + Text;
  if (Saga.Engine.GetTextLength(FLogStr) > FLen) then
  begin
    Delete(FLogStr, FLen, Saga.Engine.GetTextLength(FLogStr));
    FLogStr := FLogStr + '...';
  end;
end;

procedure TLog.Clear;
begin
  FLogStr := '';
end;

procedure TLog.ClearTags;
var
  I: Integer;
  F: Boolean;
begin
  F := False;
  for I := 1 to Saga.Engine.GetTextLength(FLogStr) do
  begin
    if (FLogStr[I] = '[') then
      F := True;
    if (FLogStr[I] = ']') then
    begin
      FLogStr[I] := '/';
      F := False;
    end;
    if F then
      FLogStr[I] := '/';
  end;
  FLogStr := StringReplace(FLogStr, '/', '', [rfReplaceAll]);
end;

constructor TLog.Create(Len: Word);
begin
  FLen := Len;
  Clear;
end;

function TLog.Get: string;
begin
  Result := FLogStr;
end;

procedure TLog.LoadFromFile(FileName: string);
var
  S: TStringlist;
begin
  S := TStringlist.Create;
  try
    S.LoadFromFile(FileName{$IFNDEF FPC}, TEncoding.UTF8{$ENDIF});
    FLogStr := S.Text;
  finally
    S.Free;
  end;
end;

procedure TLog.SaveToFile(FileName: string);
var
  S: TStringlist;
begin
  S := TStringlist.Create;
  try
    S.Text := FLogStr;
    S.SaveToFile(FileName{$IFNDEF FPC}, TEncoding.UTF8{$ENDIF});
  finally
    S.Free;
  end;
end;

procedure TLog.Render(Left, Top, Width: Word);
begin
  Saga.Engine.ForegroundColor(Saga.Colors.clSplText);
  Saga.Engine.Print(Get, Rect(Left, Top, Width, 0));
end;

{$ENDREGION 'TLog'}
{$REGION 'TQuest'}

procedure TQuest.Add(Slot: Byte; Data: string);
var
  S: string;
begin
  if (FList[Slot] = '') then
    S := ''
  else
    S := '|';
  FList[Slot] := FList[Slot] + S + Trim(Data);
end;

procedure TQuest.Clear;
var
  I: Integer;
begin
  FList.Clear;
  for I := 0 to 9 do
    FList.Append('');
end;

constructor TQuest.Create;
begin
  FList := TStringlist.Create;
  Self.Clear();
end;

destructor TQuest.Destroy;
begin
  FList.Free;
  inherited;
end;

function TQuest.Get(Slot, N: Byte): string;
var
  SL: TStringlist;
begin
  SL := TUtils.ExplodeString('|', FList[Slot]);
  if (N < SL.Count) then
    Result := Trim(SL[N])
  else
    Result := '';
end;

procedure TQuest.LoadFromFile(FileName: string);
begin
  FList.LoadFromFile(FileName{$IFNDEF FPC}, TEncoding.UTF8{$ENDIF});
end;

procedure TQuest.SaveToFile(FileName: string);
begin
  FList.SaveToFile(FileName{$IFNDEF FPC}, TEncoding.UTF8{$ENDIF});
end;

{$ENDREGION 'TQuest'}
{$REGION 'TNotification'}

procedure TNotification.Add(S: string);
begin
  FMessage := Trim(S);
  FCounter := FDuration;
end;

constructor TNotification.Create(Duration: Byte);
begin
  FMessage := '';
  FCounter := 0;
  FDuration := Duration;
end;

procedure TNotification.Dec;
begin
  if (FCounter > 0) then
    FCounter := FCounter - 1;
end;

procedure TNotification.Render(Left, Top: Word);
begin
  Saga.Engine.ForegroundColor(Saga.Colors.clNotification);
  if (FCounter > 1) then
    Saga.Engine.Print(Left, Top, FMessage);
end;

{$ENDREGION 'TNotification'}
{$REGION 'TRecs'}

procedure TRecs.Add(Slot: Byte);
var
  L, S: Byte;
  N: string;
begin
  S := Saga.Engine.Window.Width - 55;
  L := Saga.Engine.GetTextLength(Saga.Player.GetFullName);
  if (L < S) then
    N := StringOfChar(#32, S - L)
  else
    N := '';
  Saga.List[Slot] := Format('%s%d', [Saga.Player.GetFullName + N,
    Saga.Player.Score]);
  Saga.List.SaveToFile(FFileName{$IFNDEF FPC}, TEncoding.UTF8{$ENDIF});
end;

constructor TRecs.Create(FileName: string);
begin
  FFileName := FileName;
end;

procedure TRecs.Load;
begin
  Saga.ClearSlots;
  if FileExists(FFileName) then
    Saga.List.LoadFromFile(FFileName{$IFNDEF FPC}, TEncoding.UTF8{$ENDIF});
end;

procedure TRecs.Save;
var
  Slot, I: Byte;
  Score: Word;
begin
  if (Saga.Player.Score = 0) then
    Exit;
  Self.Load;
  for Slot := 0 to 9 do
  begin
    if (Saga.List[Slot] <> '') then
    begin
      Score := StrToIntDef(Trim(Copy(Saga.List[Slot],
        Pos(#32#32, Saga.List[Slot]),
        Saga.Engine.GetTextLength(Saga.List[Slot]))), 0);
      if (Score < Saga.Player.Score) then
      begin
        if (Slot < 9) then
          for I := 9 downto Slot + 1 do
            Saga.List[I] := Saga.List[I - 1];
        Add(Slot);
        Break;
      end
      else
        Continue;
    end
    else
    begin
      Add(Slot);
      Break;
    end;
  end;
  TStageRecMenu(Saga.Stages.GetStage(stRecMenu)).RecPos := Slot;
end;

{$ENDREGION 'TRecs'}
{$REGION 'TLanguage'}

function TLanguage.Get(S: string): string;
var
  I: Integer;
begin
  S := Trim(S);
  I := FID.IndexOf(S);
  if (I < 0) or (FValue[I] = '') then
    Result := S
  else
    Result := FValue[I];

  Result := StringReplace(Result, '<RED>', '[color=red]', [rfReplaceAll]);
  Result := StringReplace(Result, '<GREEN>', '[color=green]', [rfReplaceAll]);
  Result := StringReplace(Result, '<BLUE>', '[color=blue]', [rfReplaceAll]);
  Result := StringReplace(Result, '</>', '[/color]', [rfReplaceAll]);
end;

constructor TLanguage.Create;
begin
  FID := TStringlist.Create;
  FValue := TStringlist.Create;
  FCurrent := 'russian';
end;

destructor TLanguage.Destroy;
begin
  FreeAndNil(FID);
  FreeAndNil(FValue);
  inherited;
end;

procedure TLanguage.LoadFromFile(FileName: string);
var
  SL: TStringlist;
  I, J: Integer;
  S: string;
begin
  if not FileExists(FileName) then
    Exit;
  SL := TStringlist.Create;
  try
    SL.LoadFromFile(FileName{$IFNDEF FPC}, TEncoding.UTF8{$ENDIF});
    for I := 0 to SL.Count - 1 do
    begin
      S := Trim(SL[I]);
      J := Pos('=', S);
      Self.FID.Append(Trim(Copy(S, 1, J - 1)));
      Self.FValue.Append(Trim(Copy(S, J + 1, Saga.Engine.GetTextLength(S))));
    end;
  finally
    SL.Free;
  end;
end;

procedure TLanguage.Clear;
begin
  FID.Clear;
  FValue.Clear;
end;

{$ENDREGION 'TLanguage'}
{$REGION 'TColors'}

function TColors.GetColor(Color: TColorsEnum): Integer;
begin
  Result := FColors[Color];
end;

function TColors.GetColor(Color: string): Integer;
var
  I: TColorsEnum;
begin
  Result := $00FFFFFF;
  for I := Low(TColorsEnum) to High(TColorsEnum) do
    if (ColorsStr[I] = Color) then
    begin
      Result := GetColor(I);
      Exit;
    end;
end;

procedure TColors.LoadFromFile(FileName: string);
var
  I: TColorsEnum;
  F: TIniFile;
  R, G, B: Byte;
begin
  F := TIniFile.Create(FileName);
  try
    for I := Low(TColorsEnum) to High(TColorsEnum) do
    begin
      R := F.ReadInteger(ColorsStr[I], 'R', 0);
      G := F.ReadInteger(ColorsStr[I], 'G', 0);
      B := F.ReadInteger(ColorsStr[I], 'B', 0);
      FColors[I] := (R or (G shl 8) or (B shl 16));
    end;
  finally
    F.Free;
  end;
  SetColors;
end;

procedure TColors.SetColors;
begin
  clNotification := GetColor(ceYellow);
  clTitle := GetColor(ceYellow);
  clHotKey := GetColor(ceGreen);
  clButton := GetColor(ceLGray);
  clSplText := GetColor(ceLGray);
  clGoldText := GetColor(ceYellow);
  clAlertText := GetColor(ceRed);
  clMenuAct := GetColor(ceYellow);
  clMenuDef := GetColor(ceLGray);
  clCursor := GetColor(ceDGray);
end;

{$ENDREGION 'TColors'}
{$REGION 'TConfig'}

procedure TConfig.LoadFromFile(FileName: string);
var
  F: TIniFile;
begin
  F := TIniFile.Create(FileName);
  try

  finally
    F.Free;
  end;
end;

{$ENDREGION 'TConfig'}
{$REGION 'TUI'}

procedure TUI.DrawChar(X, Y: Integer; Symbol: System.Char;
  ForegroundColor, BackgroundColor: Integer);
begin
  FEngine.BackgroundColor(BackgroundColor);
  FEngine.ForegroundColor(ForegroundColor);
  FEngine.Print(X, Y, Symbol);
end;

procedure TUI.DrawKey(X, Y: Integer; Caption, Key: string; Active: Boolean);
var
  S: string;
begin
  S := kcBegin + Key + kcEnd;
  if Active then
    FEngine.ForegroundColor(Saga.Colors.clHotKey)
  else
    FEngine.ForegroundColor(FEngine.DarkColor(Saga.Colors.clHotKey, 60));
  FEngine.Print(X, Y, S);
  FEngine.ForegroundColor(Saga.Colors.clButton);
  FEngine.Print(X + FEngine.GetTextLength(S) + 1, Y, Caption);
end;

procedure TUI.DrawKey(X, Y: Integer; Caption, Key: string; Align: TAlign;
  Active: Boolean);
var
  S: string;
  L: Integer;
begin
  case Align of
    aLeft:
      DrawKey(X, Y, Caption, Key, Active);
    aCenter:
      begin
        S := kcBegin + Key + kcEnd + ' ' + Caption;
        L := ((((FEngine.Char.Width * FEngine.Window.Width) +
          (X * FEngine.Char.Width)) div 2)) -
          ((FEngine.GetTextLength(S) * FEngine.Char.Width) div 2);
        DrawKey(L div FEngine.Char.Width, Y, Caption, Key, Active);
      end;
    aRight:
      begin

      end;
  end;
end;

constructor TUI.Create(AEngine: TEngine);
begin
  Self.FEngine := AEngine;
end;

procedure TUI.DrawTitle(Y: Word; Text: string);
begin
  Engine.ForegroundColor(Saga.Colors.clTitle);
  Engine.Print(0, Y - 1, Text, aCenter);
  Engine.Print(0, Y, StringOfChar('=', Engine.GetTextLength(Text)), aCenter);
end;

{$ENDREGION 'TUI'}
{$REGION 'TScript'}

constructor TScript.Create;
begin
  CloseTag := 'close';
  FList := TStringlist.Create;
  FVars := TVars.Create;
  FIsNext := False;
  FIsIf := False;
end;

destructor TScript.Destroy;
begin
  FVars.Free;
  FList.Free;
end;

procedure TScript.Clear;
begin
  FVars.Clear;
  FList.Clear;
end;

procedure TScript.LoadFromFile(const FileName: string);
var
  I: Integer;
  S: string;
begin
  FList.LoadFromFile(FileName{$IFNDEF FPC}, TEncoding.UTF8{$ENDIF});
  for I := FList.Count - 1 downto 0 do
  begin
    S := Trim(FList[I]);
    if (S = '') or (S[1] = ';') then
    begin
      FList.Delete(I);
      Continue;
    end;
    if (Pos(';', S) > 0) then
      Delete(S, Pos(';', S), Saga.Engine.GetTextLength(S));
    FList[I] := S;
  end;
  // ShowMessage(SL.Text);
end;

function TScript.GetSource(const ID: string): string;
var
  I: Integer;
  Flag: Boolean;
begin
  Flag := False;
  Result := '';
  for I := 0 to FList.Count - 1 do
  begin
    if (FList[I] = ':' + ID) then
    begin
      Flag := True;
      Continue;
    end;
    if Flag then
    begin
      if (FList[I] = 'end') then
        Break;
      Result := Result + FList[I] + #13#10;
    end;
  end;
  // ShowMessage(Result);
end;

procedure TScript.Next(const ID: string);
var
  Link, Code: string;
  P: Integer;
begin
  Code := '';
  Link := Trim(ID);
  P := Pos('(', Link);
  if (P > 0) then
  begin
    Code := Trim(Copy(Link, P + 1, Saga.Engine.GetTextLength(Link) - P - 1));
    Link := Trim(Copy(Link, 1, P - 1));
  end;
  if (Code <> '') then
    Self.RunCode(Code);
  if (Link = CloseTag) then
  begin
    Saga.Stages.SetStage(stGame);
    Exit;
  end;
  FIsNext := False;
  Exec(Link);
end;

procedure TScript.Exec(const ID: string);
var
  L: TStringlist;
  I: Integer;
begin
  L := TStringlist.Create;
  L.Text := Self.GetSource(ID);
  for I := 0 to L.Count - 1 do
    if FIsNext then
      Continue
    else
      Self.Run(L[I]);
  L.Free;
end;

procedure TScript.RunCode(const Code: string);
var
  I: Integer;
  SL: TStringlist;
begin
  SL := TUtils.ExplodeString('&', Code);
  for I := 0 to SL.Count - 1 do
    if FIsNext then
      Continue
    else
      Self.Run(Trim(SL[I]));
end;

procedure TScript.Run(const Code: string);
var
  S, L: string;
  I, J, K, E: Integer;
  SL: TStringlist;

  function GetLastCode(Tag: string; Code: string): string;
  begin
    Result := Trim(Copy(Code, Saga.Engine.GetTextLength(Tag) + 2,
      Saga.Engine.GetTextLength(Code)));
  end;

  procedure SetNext(Flag: Boolean);
  begin
    Exec(GetLastCode('goto', Code));
    FIsNext := Flag;
  end;

  function IsTag(Tag: string; ACode: string = ''): Boolean;
  var
    R: string;
  begin
    ACode := Trim(ACode);
    if (ACode = '') then
      R := Copy(Code, 1, Saga.Engine.GetTextLength(Tag))
    else
      R := ACode;
    Result := R = Tag;
  end;

  function GetIf(K: System.Char; S: string): Boolean;
  var
    N: string;
    V, A: Integer;
  begin
    Result := False;
    N := AnsiLowerCase(Trim(Copy(S, 1, Pos(K, S) - 1)));
    Val(Trim(Copy(S, Pos(K, S) + 1, Saga.Engine.GetTextLength(S))), V, A);
    if (Vars.Has(N)) then
      A := Vars.GetInt(N)
    else
      A := 0;
    case K of
      '=':
        Result := not(A = V);
      '>':
        Result := not(A > V);
      '<':
        Result := not(A < V);
    end;
  end;

begin
  if IsTag('endif') then
    FIsIf := False;

  if FIsIf then
    Exit;

  if IsTag('pln') then
    Saga.Log[lgDialog].Add(GetLastCode('pln', Code));

  if IsTag('log') then
    Saga.Log[lgGame].Add(GetLastCode('log', Code));

  if IsTag('box') then
  begin
    S := GetLastCode('box', Code);
    if (Vars.Has(S)) then
      TUtils.Box(Vars.GetInt(S))
    else
      TUtils.Box(S);
  end;

  if IsTag('btn') then
  begin
    S := GetLastCode('btn', Code);
    L := Trim(Copy(S, 1, Pos(',', S) - 1));
    Delete(S, 1, Pos(',', S));
    S := Trim(S);
    TStageDialog(Saga.Stages.GetStage(stDialog)).LinkList.Append(S, L);
  end;

  if IsTag('qlog') then
  begin
    S := GetLastCode('qlog', Code);
    L := Trim(Copy(S, 1, Pos(':', S) - 1));
    Delete(S, 1, Pos(':', S));
    Val(L, I, E);
    if IsTag('begin', S) then
    begin
      Saga.Log[lgGame].Add(__('The new quest is added to the log.'));
      Exit;
    end;
    if IsTag(CloseTag, S) then
    begin
      Saga.Log[lgGame].Add(__('You have completed the quest.'));
      Saga.Quest.Add(I - 1, __('I have completed this quest.'));
      Exit;
    end;
    Saga.Quest.Add(I - 1, S);
  end;

  if (Pos('=', Code) > 0) and not IsTag('if') and not IsTag('btn') then
  begin
    S := AnsiLowerCase(Trim(Copy(Code, 1, Pos('=', Code) - 1)));
    L := Trim(Copy(Code, Pos('=', Code) + 1, Saga.Engine.GetTextLength(Code)));
    Vars.SetStr(S, L);
    // Box(S + '=>' + L);
  end;

  if IsTag('if') then
  begin
    S := Trim(Copy(Code, 4, Pos('then', Code) - 4));
    if (Pos('=', S) > 0) then
      FIsIf := GetIf('=', S)
    else if (Pos('>', S) > 0) then
      FIsIf := GetIf('>', S)
    else if (Pos('<', S) > 0) then
      FIsIf := GetIf('<', S);
  end;

  // Map:Creature:Dialog
  if IsTag('dialog') then
  begin
    S := GetLastCode('dialog', Code);
    SL := TUtils.ExplodeString(':', Code);
    I := StrToIntDef(SL[0], 0);
    J := StrToIntDef(SL[1], 0);
    K := StrToIntDef(SL[2], 0);
    Saga.World.GetMapCreatures(I).Get(J).Dialog := K;
  end;

  if IsTag('exp') then
  begin
    S := GetLastCode('exp', Code);
    Saga.Player.AddExp(StrToInt(S));
  end;

  if IsTag('heal') then
  begin
    Saga.Player.Atr[atLife].SetToMax;
  end;

  if IsTag('goto') then
    SetNext(True);

  if IsTag('proc') then
    SetNext(False);

  if IsTag('exit') then
    FIsNext := True;

  if IsTag(CloseTag) then
    Saga.Stages.SetStage(stGame);
end;

{$ENDREGION 'TScript'}
{$REGION 'TVars'}

procedure TVars.Clear;
begin
  FID.Clear;
  FValue.Clear;
end;

function TVars.Count: Integer;
begin
  Result := FID.Count;
end;

constructor TVars.Create;
begin
  FID := TStringlist.Create;
  FValue := TStringlist.Create;
end;

destructor TVars.Destroy;
begin
  FID.Free;
  FValue.Free;
  inherited;
end;

procedure TVars.Empty(const AVar: string);
var
  I: Integer;
begin
  I := FID.IndexOf(AVar);
  if (I < 0) then
    Exit;
  FID.Delete(I);
  FValue.Delete(I);
end;

function TVars.GetStr(const AVar: string): string;
var
  I: Integer;
begin
  I := FID.IndexOf(AVar);
  if I < 0 then
    Result := ''
  else
    Result := FValue[I];
end;

procedure TVars.SetStr(const AVar, AValue: string);
var
  I: Integer;
begin
  I := FID.IndexOf(AVar);
  if (I < 0) then
  begin
    FID.Append(AVar);
    FValue.Append(AValue);
  end
  else
    FValue[I] := AValue;
end;

function TVars.GetInt(const AVar: string): Integer;
var
  S: string;
  E: Integer;
begin
  S := Trim(GetStr(AVar));
  if S = '' then
    Result := 0
  else
    Val(S, Result, E);
end;

procedure TVars.SetInt(const AVar: string; const AValue: Integer);
begin
  SetStr(AVar, Format('%d', [AValue]));
end;

function TVars.Has(const AVar: string): Boolean;
begin
  Result := FID.IndexOf(AVar) > -1;
end;

procedure TVars.LoadFromFile(const FileName: string);
var
  A: TStringlist;
  I, J: Integer;
  S: string;
begin
  A := TStringlist.Create;
  try
    Self.Clear;
{$IFNDEF FPC}A.WriteBOM := False; {$ENDIF}
    A.LoadFromFile(FileName{$IFNDEF FPC}, TEncoding.UTF8{$ENDIF});
    for I := 0 to A.Count - 1 do
    begin
      S := Trim(A[I]);
      J := Pos(',', S);
      Self.FID.Append(Trim(Copy(S, 1, J - 1)));
      Self.FValue.Append(Trim(Copy(S, J + 1, Saga.Engine.GetTextLength(S))));
    end;
  finally
    A.Free;
  end;
end;

procedure TVars.SaveToFile(const FileName: string);
var
  I: Integer;
  A: TStringlist;
begin
  A := TStringlist.Create;
{$IFNDEF FPC}A.WriteBOM := False; {$ENDIF}
  for I := 0 to FID.Count - 1 do
    A.Append(FID[I] + ',' + FValue[I]);
  A.SaveToFile(FileName{$IFNDEF FPC}, TEncoding.UTF8{$ENDIF});
  A.Free;
end;

{$ENDREGION 'TVars'}
{$REGION 'TBattle'}

constructor TBattle.Create;
begin

end;

destructor TBattle.Destroy;
begin

  inherited;
end;

procedure TBattle.EnemyMove;
begin
  Saga.Log[lgBattle].Add(Format('%s атакует тебя (%d).', [EnemyName, 5]));
end;

function TBattle.EnemyName: string;
begin
  Result := Saga.World.CurrentCreatures.Get(ID).Name;
end;

procedure TBattle.Finish;
begin
  Saga.Stages.SetStage(stGame);
  Saga.Log[lgGame].Add('Ты вышел из боя.');
end;

procedure TBattle.PlayerMove;
begin
  Saga.Log[lgBattle].Add(Format('Ты атакуешь %s (%d)', [EnemyName, 5]));
  EnemyMove();
end;

procedure TBattle.Start(ID: Byte);
begin
  Self.ID := ID;
  Saga.Log[lgBattle].Clear;
  if (Math.RandomRange(1, 3) = 1) then
  begin
    Saga.Log[lgBattle].Add('Твои навыки позволяют тебе атаковать первым.');
  end
  else
  begin
    Saga.Log[lgBattle].Add(Format('%s неожиданно нападает на тебя первым.',
      [EnemyName]));
    EnemyMove();
  end;
end;

{$ENDREGION 'TBattle'}

end.
