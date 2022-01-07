unit uBonus;

interface

uses
  Types, UITypes, FMX.Types, FMX.Graphics, System.UIConsts, system.Generics.Collections, FMX.Ani, FMX.Objects,
  System.Classes, uConsts;

type
  TTypeBonus = (points, doubleTir);
  TBonus = class(TImage)
  private
    fSpeedX : single;
    fValeur : integer;
    fTypeBonus : TTypeBonus;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Update;
    property VitesseX : single read fSpeedX write fSpeedX;
    property Valeur : integer read fValeur write fValeur;
    property TypeBonus : TTypeBonus read fTypeBonus write fTypeBonus;
  end;

implementation

{ TBonus }

constructor TBonus.Create(AOwner: TComponent);
begin
  inherited;
  height := 18;
  width := 110;
  VitesseX := 3 + random(8);
  Valeur := 1000;
  TypeBonus := TTypeBonus.points;
end;

destructor TBonus.Destroy;
begin
  inherited;
end;

procedure TBonus.Update;
begin
  Position.X := Position.X - VitesseX;
  if Position.X < -width then begin
    visible := false;
  end;
end;

end.
