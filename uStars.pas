unit uStars;

interface

uses
  Types, UITypes, FMX.Types, FMX.Graphics, System.UIConsts, system.Generics.Collections;

type
  TStar = class
    Position: TPointF;
    Speed: single;
    procedure Draw(const c: TCanvas);
  end;

  TStars = class
  private
    FWidth, FHeight: single;
    FStars: TList<TStar>;
    FNbStars : integer;
    procedure setNbStars(const Value: integer);
    procedure CreateStars;
  public
    constructor Create(const AWidth, AHeight: single; nbStars : integer);
    destructor Destroy; override;
    procedure Update;
    procedure Draw(const c: TCanvas);
    property StarsCount : integer read FNbStars write setNbStars;
    property Width : single read FWidth write FWidth;
    property Height : single read FHeight write FHeight;
  end;

implementation

uses
  Classes;

  { TStars }

constructor TStars.Create(const AWidth, AHeight: single; nbStars : integer);
begin
  FWidth := AWidth;
  FHeight := AHeight;
  FStars := TList<TStar>.Create;
  FNbStars := nbStars;
  CreateStars;
end;

destructor TStars.Destroy;
begin
  for var s in FStars do begin
    FStars.Remove(s);
    s.Free;
  end;
  FStars.free;
  inherited;
end;

procedure TStars.Draw(const c: TCanvas);
begin
  for var s in FStars do
    s.Draw(c);
end;

procedure TStars.CreateStars;
begin
  for var i := 0 to FNbStars-1 do begin
    var s := TStar.Create;
    s.Position := PointF(random(round(FWidth)), random(round(FHeight)));
    s.Speed := 5 + random(3);
    FStars.Add(s);
  end;
end;

procedure TStars.setNbStars(const Value: integer);
begin
  if value <> FNbStars then begin
    FStars.Clear;
    FNbStars := Value;
    CreateStars;
  end;
end;

procedure TStars.Update;
begin
  for var s in FStars do begin
    if s.Position.X < 0 then s.Position := PointF(FWidth, random(round(FHeight)))
    else s.Position.X := s.Position.X - s.Speed;
  end;
end;

{ TStar }
procedure TStar.Draw(const c: TCanvas);
begin
  if Speed > 6 then
    c.Stroke.Color := TAlphaColorRec.white
  else if Speed > 5 then
    c.Stroke.Color := TAlphaColorRec.MedGray
  else
      c.Stroke.Color := TAlphaColorRec.Slategray;
  c.Stroke.Thickness := 1;
  c.Stroke.Kind := TBrushKind.Solid;
  c.DrawLine(PointF(Position.X-6, Position.Y), PointF(Position.X+6, Position.Y), 1);
  c.DrawLine(PointF(Position.X, Position.Y-6), PointF(Position.X, Position.Y+6), 1);
end;

end.

