unit WorldEditor.Classes;

interface

uses Windows, Graphics, Types, Controls, ForgottenSaga.Classes,
  ForgottenSaga.Entities;

{$REGION ' TEditor '}

type
  TEditor = class(TSaga)
  private
    FMap: TMap;
    FPos: TPoint;
    FToolBarHeight: Integer;
    FTiles: TTiles;
    FTile: TTiles.TTileEnum;
    FCurrentMapFile: string;
    FModified: Boolean;
    FCreatures: TCreatures;
    FItems: TItems;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RenderTerrain;
    procedure RenderObjects;
    procedure RenderItems;
    procedure RenderCreatures;
    procedure MouseMove(Layer: TMap.TLayerEnum; X, Y: Integer);
    procedure MouseDown(Layer: TMap.TLayerEnum; Button: TMouseButton; X, Y: Integer);
    procedure KeyDown(var Key: Word);
    property CurrentMapFile: string read FCurrentMapFile write FCurrentMapFile;
    property Pos: TPoint read FPos write FPos;
    property ToolBarHeight: Integer read FToolBarHeight write FToolBarHeight;
    property Map: TMap read FMap write FMap;
    property Tiles: TTiles read FTiles write FTiles;
    property Tile: TTiles.TTileEnum read FTile write FTile;
    property Modified: Boolean read FModified write FModified;
    property Creatures: TCreatures read FCreatures write FCreatures;
    property Items: TItems read FItems write FItems;
  end;

var
  Editor: TEditor;

{$ENDREGION ' TEditor '}

implementation

uses Engine;

{$REGION ' TEditor '}

constructor TEditor.Create;
begin
  inherited Create(TMap.MapWidth, TMap.MapHeight);
  Map := TMap.Create;
  Creatures := TCreatures.Create;
  Items := TItems.Create;
  CurrentMapFile := '';
  Modified := False;
  // Tiles
  Tiles := TTiles.Create;
  Tiles.LoadFromFile(TUtils.GetPath('resources') + 'terrain.ini');
  // Tiles.LoadFromFile(GetPath('resources') + 'objects.ini');
end;

destructor TEditor.Destroy;
begin
  Items.Free;
  Creatures.Free;
  Tiles.Free;
  Map.Free;
  inherited;
end;

procedure TEditor.KeyDown(var Key: Word);
begin

end;

procedure TEditor.MouseDown(Layer: TMap.TLayerEnum; Button: TMouseButton; X, Y: Integer);
begin
  case Button of
    mbLeft:
      begin
        case Layer of
          lrTerrain, lrObjects:
            Map.SetTile(Pos.X, Pos.Y, Layer, Self.Tile);
        end;
        Modified := True;
      end;
    mbRight:
      begin
        case Layer of
          lrTerrain, lrObjects:
            Map.SetTile(Pos.X, Pos.Y, Layer, tNone);
        end;
        Modified := True;
      end;
  end;
end;

procedure TEditor.MouseMove(Layer: TMap.TLayerEnum; X, Y: Integer);
begin
  Pos := Point(X div Engine.Char.Width, (Y - ToolBarHeight)
    div Engine.Char.Height);
  if (GetKeyState(VK_LBUTTON) < 0) and (Map.CellInMap(Pos.X, Pos.Y)) then
    Map.SetTile(Pos.X, Pos.Y, Layer, Self.Tile);
end;

procedure TEditor.RenderCreatures;
var
  I: Integer;
  E: TCreature;
begin
  for I := 0 to Creatures.Count - 1 do
  begin
    E := Creatures.Get(I);
    Editor.UI.DrawChar(E.Pos.X, E.Pos.Y, E.Symbol, E.Color, E.BackColor);
  end;
end;

procedure TEditor.RenderItems;
var
  I: Integer;
  E: TItem;
begin
  for I := 0 to Items.Count - 1 do
  begin
    E := Items.Get(I);
    Editor.UI.DrawChar(E.Pos.X, E.Pos.Y, E.Symbol, E.Color, E.BackColor);
  end;
end;

procedure TEditor.RenderObjects;
var
  X, Y: Integer;
  TerTile, ObjTile: TTiles.TTileProp;
begin
  for Y := 0 to Map.Height - 1 do
    for X := 0 to Map.Width - 1 do
      if not Map.HasTile(tNone, X, Y, lrObjects) then
      begin
        TerTile := Editor.Tiles.GetTile(Map.GetTile(X, Y, lrTerrain));
        ObjTile := Editor.Tiles.GetTile(Map.GetTile(X, Y, lrObjects));
        Editor.UI.DrawChar(X, Y, ObjTile.Symbol, ObjTile.Color,
          Editor.Engine.DarkColor(TerTile.Color, TTiles.TileDarkPercent));
      end;
end;

procedure TEditor.RenderTerrain;
var
  X, Y: Integer;
  TerTile: TTiles.TTileProp;
begin
  for Y := 0 to Map.Height - 1 do
    for X := 0 to Map.Width - 1 do
    begin
      TerTile := Editor.Tiles.GetTile(Map.GetTile(X, Y, lrTerrain));
      Editor.UI.DrawChar(X, Y, TerTile.Symbol, TerTile.Color,
        Editor.Engine.DarkColor(TerTile.Color, TTiles.TileDarkPercent));
    end;
end;

{$ENDREGION ' TEditor '}

end.
