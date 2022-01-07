program shmup;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {fMain},
  uStars in 'uStars.pas',
  uEnnemis in 'uEnnemis.pas',
  uConsts in 'uConsts.pas',
  uSounds in 'uSounds.pas',
  uBonus in 'uBonus.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape];
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
