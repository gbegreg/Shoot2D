unit uEnnemis;

interface

uses
  Types, UITypes, FMX.Types, FMX.Graphics, System.UIConsts, system.Generics.Collections, FMX.Ani, FMX.Objects,
  System.Classes, uConsts;

type
  TEnnemi = class(TImage)
  private
    fSpeedX : single;
    fLife, fPoints : integer;
    fAnimationImage : TBitmapListAnimation;
    fAnimationY : TFloatAnimation;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property VitesseX : single read fSpeedX write fSpeedX;
    property PointVie : integer read fLife write fLife;
    property Points : integer read fPoints write fPoints;
    property Animation : TBitmapListAnimation read fAnimationImage write fAnimationImage;
    property AnimationY : TFloatAnimation read fAnimationY write fAnimationY;
  end;

  TEnnemis = class
  private
    FWidth, FHeight: single;
    FNbEnnemis : integer;
    fParent : TFMXObject;
  public
    constructor Create(const AWidth, AHeight: single; nbEnnemis : integer; parent : TFMXObject);
    destructor Destroy; override;
    var listeEnnemis: TList<TEnnemi>;
    procedure CreateEnnemis;
    procedure Update;
    property Width : single read FWidth write FWidth;
    property Height : single read FHeight write FHeight;
  end;

implementation
uses uMain;

{ TEnnemi }

constructor TEnnemi.Create(AOwner: TComponent);
begin
  inherited;
  height := 48;   // x3
  width := 57;
  fAnimationImage := TBitmapListAnimation.Create(nil);
  fAnimationImage.Parent := self;
  fAnimationImage.PropertyName := 'bitmap';
  fAnimationY := TFloatAnimation.Create(nil);
  fAnimationY.Parent := self;
  fAnimationY.Duration := 1+random(4);
  fAnimationY.PropertyName := 'position.Y';
  fAnimationY.Loop := true;
  fAnimationY.AutoReverse := true;
  fAnimationY.AnimationType := TAnimationType.InOut;
  fAnimationY.Interpolation := TInterpolationType.Sinusoidal;
  fAnimationY.StartValue := Position.Y;
  fAnimationY.StopValue := Position.Y + 100 + random(200);
  fAnimationY.Delay := random;

  VitesseX := 3 + random(5);
  PointVie := 1;
  fPoints := 100;
end;

destructor TEnnemi.Destroy;
begin
  fAnimationImage.Stop;
  fAnimationImage.Stop;
  fAnimationImage.DisposeOf;
  fAnimationY.DisposeOf;
  inherited;
end;

{ TEnnemis }

constructor TEnnemis.Create(const AWidth, AHeight: single; nbEnnemis: integer; parent : TFMXObject);
begin
  FWidth := AWidth;
  FHeight := AHeight;
  FParent := parent;
  listeEnnemis := TList<TEnnemi>.Create;
  FNbEnnemis := nbEnnemis;
  CreateEnnemis;
end;

procedure TEnnemis.CreateEnnemis;
begin
  for var i := 1 to FNbEnnemis do begin
    var unEnnemi := TEnnemi.Create(FParent);
    unEnnemi.parent := FParent;
    unEnnemi.Position.X := FWidth + 50 + random(round(FWidth));
    unEnnemi.Position.Y := 40 + random(round(FHeight)-300);

    case random(9) of
      1,6: begin
           unEnnemi.fAnimationImage.AnimationBitmap := fMain.ennemi2;
           unEnnemi.PointVie := 4;
           unEnnemi.fPoints := 200;
           unEnnemi.fAnimationImage.Duration := 0.3;
         end;
      3: begin
           unEnnemi.fAnimationImage.AnimationBitmap := fMain.ennemi1;
           unEnnemi.PointVie := 8;
           unEnnemi.fPoints := 500;
           unEnnemi.fAnimationImage.Duration := 0.2;
         end;
      else begin
           unEnnemi.fAnimationImage.AnimationBitmap := fMain.ennemi3;
           unEnnemi.PointVie := 1;
           unEnnemi.fPoints := 100;
           unEnnemi.fAnimationImage.Duration := 0.4;
         end;
    end;

    unEnnemi.fAnimationImage.AnimationCount := 8;
    unEnnemi.fAnimationImage.Loop := true;
    unEnnemi.fAnimationImage.Enabled := true;
    unEnnemi.fAnimationY.StartValue := unEnnemi.Position.Y;
    unEnnemi.fAnimationY.StopValue := unEnnemi.Position.Y + 100 + random(200);
    unEnnemi.fAnimationY.Start;

    listeEnnemis.Add(unEnnemi);
  end;
end;

destructor TEnnemis.Destroy;
begin
  for var e in listeEnnemis do begin
    listeEnnemis.Remove(e);
    e.DisposeOf;
  end;
  listeEnnemis.Free;
  inherited;
end;

procedure TEnnemis.Update;
begin
  for var e in listeEnnemis do begin
    e.Position.X := e.Position.X - e.VitesseX;
    if (e.Position.X < -50) or (e.PointVie = 0) then begin
      listeEnnemis.Remove(e);
      e.fAnimationImage.Stop;
      e.fAnimationY.Stop;
      e.disposeOf;
    end;
  end;

  if listeEnnemis.Count = 0 then begin
    if FNbEnnemis < MAX_ENNEMIS then inc(FNbEnnemis);
    CreateEnnemis;
  end;
end;

end.
