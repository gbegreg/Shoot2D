unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects, uStars,
  FMX.Ani, FMX.Layouts, system.Generics.Collections, uConsts, FMX.Media, uSounds,
  uEnnemis, FMX.Controls.Presentation, FMX.StdCtrls, uBonus, FMX.Effects, system.Threading, System.IOUtils;

type
  TfMain = class(TForm)
    Joueur: TImage;
    gameLoop: TFloatAnimation;
    layFondEtoile: TLayout;
    imgReady: TImage;
    aniIntro: TFloatAnimation;
    aniGo: TFloatAnimation;
    mpMusic: TMediaPlayer;
    mpTir: TMediaPlayer;
    layInfos: TLayout;
    Layout2: TLayout;
    lblScore: TLabel;
    mpExplosion1: TMediaPlayer;
    mpEnnemiTouche: TMediaPlayer;
    mpSecours: TMediaPlayer;
    lblPoints: TLabel;
    tSpawnBonus: TTimer;
    mpBonus: TMediaPlayer;
    GradientAnimation1: TGradientAnimation;
    layGameOver: TLayout;
    imgGameover: TImage;
    lblGameover: TLabel;
    btnRejouer: TRectangle;
    lblRestart: TLabel;
    layZoneJeu: TLayout;
    layIHMMobile: TLayout;
    btnTir: TImage;
    layJoystick: TLayout;
    layHaut: TLayout;
    imgHaut: TImage;
    layBas: TLayout;
    imgBas: TImage;
    layCentre: TLayout;
    imgGauche: TImage;
    imgDroite: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure gameLoopProcess(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure aniIntroProcess(Sender: TObject);
    procedure aniIntroFinish(Sender: TObject);
    procedure aniGoFinish(Sender: TObject);
    procedure aniGoProcess(Sender: TObject);
    procedure tSpawnBonusTimer(Sender: TObject);
    procedure btnRejouerClick(Sender: TObject);
    procedure FormTouch(Sender: TObject; const Touches: TTouches; const Action: TTouchAction);
    procedure FormResize(Sender: TObject);
    procedure layFondEtoilePaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure imgHautMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure imgHautMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure imgBasMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure imgBasMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure imgDroiteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure imgDroiteMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure imgGaucheMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure imgGaucheMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure imgHautMouseLeave(Sender: TObject);
    procedure imgDroiteMouseLeave(Sender: TObject);
    procedure imgBasMouseLeave(Sender: TObject);
    procedure imgGaucheMouseLeave(Sender: TObject);
  private
    procedure gererTouches;
    procedure avancer;
    procedure reculer;
    procedure monter;
    procedure descendre;
    procedure tirer;
    procedure gererTirs;
    procedure gererCollisions;
    function enCollision(objet1, objet2: TControl): boolean;
    procedure finExplosion(Sender: TObject);
    procedure creerTir(X, Y: single);
    procedure gameover;
    procedure Initialiser;
    procedure loadImageFromResource(var uneImage : TBitmap; resourceName : string);
    procedure ExplosionAnim(x, y: single);
    function AppuyerBouton(touch: TTouch; zone: TImage): boolean;
    procedure InitialiserTouches;
    procedure allerADroite;
    procedure allerAGauche;
    procedure allerAvant;
    procedure allerArriere;
    { Déclarations privées }
  public
    { Déclarations publiques }
    stars: TStars;
    toucheAvancer, toucheReculer, toucheMonter, toucheDescendre, toucheTirer, canTir, estIntro, tirDouble : boolean;
    accelerationH, accelerationV : single;
    vaisseau, vaisseauGauche, vaisseauDroite, imgTir, ennemi1, ennemi2, ennemi3,
    explosion, bonusPoints, bonusTirDouble, ready, go : TBitmap;
    listeTirs : TList<TImage>;
    ennemis : TEnnemis;
    unBonus : TBonus;
    score, jeuWidth, jeuHeight : integer;
  end;

var
  fMain: TfMain;

implementation

{$R *.fmx}

procedure TfMain.gameLoopProcess(Sender: TObject);
begin
  RePlaySound(mpMusic);
  lblPoints.text := score.ToString;

  if not(estIntro) then begin
    gererTouches;
    ennemis.Update;
    unBonus.Update;
    gererTirs;
    gererCollisions;
  end;
end;

procedure TfMain.gererTouches;
begin
  if toucheAvancer then avancer;
  if toucheReculer then reculer;
  if toucheMonter then monter;
  if toucheDescendre then descendre;
  if toucheTirer then tirer;
end;

procedure TfMain.imgBasMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  allerADroite;
end;

procedure TfMain.imgBasMouseLeave(Sender: TObject);
begin
  toucheDescendre := false;
  joueur.Bitmap := vaisseau;
end;

procedure TfMain.imgBasMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  toucheDescendre := false;
  joueur.Bitmap := vaisseau;
end;

procedure TfMain.imgDroiteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  allerAvant;
end;

procedure TfMain.imgDroiteMouseLeave(Sender: TObject);
begin
  toucheAvancer := false;
end;

procedure TfMain.imgDroiteMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  toucheAvancer := false;
end;

procedure TfMain.imgGaucheMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  allerArriere;
end;

procedure TfMain.imgGaucheMouseLeave(Sender: TObject);
begin
  toucheReculer := false;
end;

procedure TfMain.imgGaucheMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  toucheReculer := false;
end;

procedure TfMain.imgHautMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  allerAGauche;
end;

procedure TfMain.imgHautMouseLeave(Sender: TObject);
begin
  toucheMonter := false;
  joueur.Bitmap := vaisseau;
end;

procedure TfMain.imgHautMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  toucheMonter := false;
  joueur.Bitmap := vaisseau;
end;

procedure TfMain.gererCollisions;
begin
  for var e in ennemis.listeEnnemis do begin // Parcours des ennemis
    for var t in listeTirs do begin  // Collisions tir et ennemis
       if enCollision(e,t) then begin
         listeTirs.Remove(t);
         t.disposeOf;
         e.PointVie := e.PointVie -1;
         if e.PointVie = 0 then begin
           Score := Score + e.Points;
           ExplosionAnim(e.Position.X, e.Position.Y);
         end else PlaySound(mpEnnemiTouche, mpSecours);
       end;
    end;

    if enCollision(joueur,e) then begin // Collisions joueur et ennemis
      gameover;
    end;
  end;

  if unBonus.Visible then begin
    if enCollision(joueur,unBonus) then begin // Collision du joueur avec bonus
      case unBonus.TypeBonus of
        points: Score := Score + unBonus.Valeur;
        doubleTir: tirDouble := true;
      end;
      Playsound(mpBonus, mpSecours);
      unBonus.Visible := false;
    end;
  end;
end;

function TfMain.enCollision(objet1, objet2 : TControl):boolean;
begin
  result := not( (objet1.position.X > objet2.Position.X + objet2.Width) or
                 (objet1.Position.Y > objet2.Position.Y + objet2.Height) or
                 (objet1.position.X + objet1.Width < objet2.Position.X) or
                 (objet1.Position.Y + objet1.Height < objet2.Position.Y) );
end;

procedure TfMain.gererTirs;
begin
  for var i in listeTirs do begin
    if i.Position.X < jeuWidth then begin
      i.Position.X := i.Position.X + VITESSE_TIR;
      i.Visible := true;
    end else begin
      listeTirs.Remove(i);
      i.Visible := false;
      i.disposeOf;
    end;
  end;
end;

procedure TfMain.aniGoFinish(Sender: TObject);
begin
  imgReady.Visible := false;
  imgReady.Opacity := 0.1;
  tSpawnBonus.Enabled := true;
  estIntro := false;
end;

procedure TfMain.aniGoProcess(Sender: TObject);
begin
  imgReady.Opacity := imgReady.Opacity + 0.01;
end;

procedure TfMain.aniIntroFinish(Sender: TObject);
begin
  imgReady.Opacity := 0.1;
  imgReady.Bitmap := go;
  aniGo.Start;
end;

procedure TfMain.aniIntroProcess(Sender: TObject);
begin
  imgReady.Opacity := imgReady.Opacity + 0.01;
end;

procedure TfMain.avancer;
begin
  if accelerationH < VITESSE_MAX then accelerationH := accelerationH + INERTIE;
  if joueur.Position.X + joueur.Width + accelerationH < jeuWidth then joueur.Position.X := joueur.Position.X + accelerationH;
end;

procedure TfMain.reculer;
begin
  if accelerationH < VITESSE_MAX then accelerationH := accelerationH + INERTIE;
  if joueur.Position.X - accelerationH > 0 then joueur.Position.X := joueur.Position.X - accelerationH;
end;

procedure TfMain.monter;
begin
  if accelerationV < VITESSE_MAX then accelerationV := accelerationV + INERTIE;
  if joueur.Position.Y - accelerationV > 0 then joueur.Position.Y := joueur.Position.Y - accelerationV;
end;

procedure TfMain.btnRejouerClick(Sender: TObject);
begin
  Initialiser;
end;

procedure TfMain.descendre;
begin
  if accelerationV < VITESSE_MAX then accelerationV := accelerationV + INERTIE;
  if joueur.Position.Y + joueur.Height + accelerationV <= jeuHeight then joueur.Position.Y := joueur.Position.Y + accelerationV;
end;

procedure TfMain.tirer;
begin
  if canTir then begin
    canTir := false;
    PlaySound(mpTir, mpSecours);
    if tirDouble then begin
      creerTir(joueur.Position.X + joueur.Width -12, joueur.Position.Y + joueur.Height * 0.5 - 17 - imgTir.Height * 0.5);
      creerTir(joueur.Position.X + joueur.Width -12, joueur.Position.Y + joueur.Height * 0.5 - 7 - imgTir.Height * 0.5);
    end else creerTir(joueur.Position.X + joueur.Width -12, joueur.Position.Y + joueur.Height * 0.5 - 12 - imgTir.Height * 0.5);
  end;
end;

procedure TfMain.creerTir(X, Y : single);
begin
  var tir := TImage.Create(nil);
  tir.Parent := layZoneJeu;
  tir.visible := false;
  tir.Position.X := X;
  tir.Position.Y := Y;
  tir.Bitmap := imgTir;
  listeTirs.Add(tir);
end;

procedure TfMain.tSpawnBonusTimer(Sender: TObject);
begin
  unBonus.Parent := layZoneJeu;
  case 1 + random(5) of
    2: begin
         unBonus.Bitmap := bonusTirDouble;
         unBonus.TypeBonus := TTypeBonus.doubleTir;
         unBonus.Width := bonusTirDouble.Width;
         unBonus.Height := bonusTirDouble.Height;
       end;
    else begin
      unBonus.Bitmap := bonusPoints;
      unBonus.TypeBonus := TTypeBonus.points;
      unBonus.Width := bonusPoints.Width;
      unBonus.Height := bonusPoints.Height;
    end;
  end;

  unBonus.Position.X := jeuWidth;
  unBonus.Position.Y := random(jeuHeight-30);
  unBonus.VitesseX := 3 + random(5);
  unBonus.Visible := true;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  jeuWidth := fMain.Width;
  jeuHeight := fMain.Height;
  {$IFDEF ANDROID}
    layIHMMobile.Visible := true;
    layIHMMobile.BringToFront;
    jeuWidth := 712;
    jeuHeight := 400;
    FullScreen := true;
  {$ENDIF ANDROID}
  Randomize;
  mpMusic.FileName := TPath.Combine(GetAppResourcesPath, 'Space-Heroes.mp3');
  mpTir.FileName := TPath.Combine(GetAppResourcesPath, 'laser.mp3');
  mpBonus.FileName := TPath.Combine(GetAppResourcesPath, 'upgrade1.mp3');
  mpExplosion1.FileName := TPath.Combine(GetAppResourcesPath, 'explosion1.mp3');
  mpEnnemiTouche.FileName := TPath.Combine(GetAppResourcesPath, 'hurt2.mp3');
  vaisseau := TBitmap.Create;
  loadImageFromResource(vaisseau, 'vaisseau');
  vaisseauGauche := TBitmap.Create;
  loadImageFromResource(vaisseauGauche, 'vaisseauGauche');
  vaisseauDroite := TBitmap.Create;
  loadImageFromResource(vaisseauDroite, 'vaisseauDroite');
  imgTir := TBitmap.Create;
  loadImageFromResource(imgTir, 'tir');
  ennemi1 := TBitmap.Create;
  loadImageFromResource(ennemi1, 'ennemi1');
  ennemi2 := TBitmap.Create;
  loadImageFromResource(ennemi2, 'ennemi2');
  ennemi3 := TBitmap.Create;
  loadImageFromResource(ennemi3, 'ennemi3');
  explosion := TBitmap.Create;
  loadImageFromResource(explosion, 'explosion1');
  bonusPoints := TBitmap.Create;
  loadImageFromResource(bonusPoints, 'bonusPoints');
  bonusTirDouble := TBitmap.Create;
  loadImageFromResource(bonusTirDouble, 'bonusTirDouble');
  ready := TBitmap.Create;
  loadImageFromResource(ready, 'ready');
  go := TBitmap.Create;
  loadImageFromResource(go, 'go');
  listeTirs := TList<TImage>.Create;
  stars := TStars.Create(jeuWidth, jeuHeight, NB_ETOILES);
  Initialiser;
end;

procedure TfMain.FormDestroy(Sender: TObject);
begin
  stars.disposeOf;
  ennemis.disposeOf;
  vaisseau.Free;
  vaisseauGauche.Free;
  vaisseauDroite.Free;
  imgTir.Free;
  listeTirs.disposeOf;
  ennemi1.Free;
  ennemi2.Free;
  ennemi3.Free;
  explosion.Free;
  bonusPoints.free;
  bonusTirDouble.Free;
  ready.Free;
  go.Free;
end;

procedure TfMain.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  case key of
    vkRight: allerAvant;
    vkLeft: allerArriere;
    vkUp: allerAGauche;
    vkDown: allerADroite;
    vkLControl, vkControl: toucheTirer := true;
  end;
end;

procedure TfMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  case key of
    vkRight: begin
          toucheAvancer := false;
          accelerationH := 0;
        end;
    vkLeft: begin
          toucheReculer := false;
          accelerationH := 0;
        end;
    vkUp: begin
          toucheMonter := false;
          accelerationV := 0;
          joueur.Bitmap := vaisseau;
        end;
    vkDown: begin
          toucheDescendre := false;
          accelerationV := 0;
          joueur.Bitmap := vaisseau;
        end;
    vkLControl, vkControl: begin
          toucheTirer := false;
          canTir := true;
        end;
  end;
end;

procedure TfMain.FormResize(Sender: TObject);
begin
  jeuWidth := fMain.Width;
  jeuHeight := fMain.Height;
  stars.Width := jeuWidth;
  stars.Height := jeuHeight;
  if assigned(ennemis) then begin
    ennemis.width := jeuWidth;
    ennemis.Height := jeuHeight;
  end;
end;

procedure TfMain.FormTouch(Sender: TObject; const Touches: TTouches; const Action: TTouchAction);
begin
  if layIHMMobile.Visible then begin // A faire que si l'IHM dédiée au mobile est visible
    toucheTirer := false;
    canTir := true;
    for var iTouch : TTouch in Touches do begin
      if appuyerBouton(iTouch, btnTir) then toucheTirer := true;
    end;
  end;
end;

function TfMain.AppuyerBouton(touch : TTouch; zone : TImage): boolean;
begin
  result := not( (touch.location.X > zone.Position.X + zone.Width) or
                 (touch.location.Y > zone.LocalToAbsolute(zone.Position.Point).Y + zone.Height) or
                 (touch.location.X  < zone.Position.X) or
                 (touch.location.Y  < zone.LocalToAbsolute(zone.Position.Point).Y) );
end;

procedure TfMain.ExplosionAnim(x, y: single);
begin
  var img := TImage.Create(layZoneJeu);
  img.Parent := layZoneJeu;
  img.Width := 57;  // x3
  img.Height := 57;
  img.Position.X := X;
  img.Position.Y := Y;
  var ani := TBitmapListAnimation.Create(img);
  ani.Parent := img;
  ani.PropertyName := 'bitmap';
  ani.AnimationCount := 6;
  ani.Duration := 0.5;
  PlaySound(mpExplosion1, mpSecours);
  ani.AnimationBitmap := explosion;
  ani.OnFinish := finExplosion;
  ani.Start;
end;

procedure TfMain.finExplosion(Sender: TObject);
begin
  ((sender as TBitmapListAnimation).Parent as TImage).disposeOf;
end;

procedure TfMain.gameover;
begin
  unBonus.Visible := false;
  joueur.Visible := false;
  tSpawnBonus.Enabled := false;
  lblGameOver.Text := 'Your score is ' + Score.ToString;
  gameloop.StopAtCurrent;
  layGameover.Visible := true;
  layGameover.BringToFront;
end;

procedure TfMain.Initialiser;
begin
  estIntro := true;
  randomize;
  if mpMusic.State = TMediaState.Playing then mpMusic.Stop;
  PlaySound(mpMusic, mpSecours);
  initialiserTouches;
  accelerationH := 0;
  accelerationV := 0;
  imgReady.Visible := true;
  imgReady.Opacity := 0.1;
  imgReady.Bitmap := ready;
  layGameOver.Visible := false;
  if assigned(ennemis) then begin
    ennemis.disposeOf;
    listeTirs.Clear;
    layZoneJeu.DeleteChildren;
  end;
  ennemis := TEnnemis.Create(jeuWidth, jeuHeight, NB_ENNEMIS_START, layZoneJeu);
  unBonus := TBonus.Create(layZoneJeu);
  unBonus.Visible := false;
  joueur.Visible := true;
  score := 0;
  tirDouble := false;
  joueur.Position.X := - joueur.Width - 50;
  joueur.Position.Y := (jeuHeight - joueur.Height) * 0.5;
  gameloop.Start;
  aniIntro.Start;
end;

procedure TfMain.layFondEtoilePaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
begin
  stars.Update;
  stars.Draw(layFondEtoile.Canvas);
end;

procedure TfMain.loadImageFromResource(var uneImage : TBitmap; resourceName : string);
begin
  var myStream := TResourceStream.Create(HInstance, resourceName, RT_RCDATA);
  try
    uneImage.LoadFromStream(myStream);
  finally
    myStream.Free;
  end;
end;

procedure TfMain.InitialiserTouches;
begin
  toucheAvancer := false;
  toucheReculer := false;
  toucheMonter := false;
  toucheDescendre := false;
  toucheTirer := false;
  canTir := true;
end;

procedure TfMain.allerADroite;
begin
  toucheMonter := false;
  toucheDescendre := true;
  joueur.Bitmap := vaisseauDroite;
end;

procedure TfMain.allerAGauche;
begin
  toucheMonter := true;
  toucheDescendre := false;
  joueur.Bitmap := vaisseauGauche;
end;

procedure TfMain.allerAvant;
begin
  toucheAvancer := true;
  toucheReculer := false;
end;

procedure TfMain.allerArriere;
begin
  toucheAvancer := false;
  toucheReculer := true;
end;

end.
