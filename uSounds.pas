unit uSounds;

interface
uses FMX.Media, System.IOUtils;

  procedure PlaySound(mediaplayer, secours: TMediaPlayer; volume : single = 0.5);
  procedure RePlaySound(mediaplayer: TMediaPlayer; volume : single = 0.5);
  function GetAppResourcesPath:string;

implementation

procedure PlaySound(mediaplayer, secours: TMediaPlayer; volume : single = 0.5);
begin
  if mediaplayer.State = TMediaState.Playing then begin
    if secours.State <> TMediaState.Playing then begin
      secours.FileName := mediaplayer.FileName;
      secours.CurrentTime := 0;
      secours.Play;
    end else begin
      mediaplayer.CurrentTime := 0;
      mediaplayer.Play;
    end;
  end else begin
    mediaplayer.CurrentTime := 0;
    mediaplayer.Play;
  end;
end;

procedure RePlaySound(mediaplayer: TMediaPlayer; volume : single = 0.5);
begin
  if mediaplayer.State = TMediaState.Stopped then begin
    mediaplayer.CurrentTime := 0;
    mediaplayer.Play;
  end;
end;

function GetAppResourcesPath:string;
{$IFDEF MSWINDOWS}
  begin
    result := TPath.GetDirectoryName(ParamStr(0));
  end;
{$ENDIF MSWINDOWS}
{$IFDEF MACOS}
  begin
    result := TPath.GetHomePath;
  end;
{$ENDIF MACOS}
{$IFDEF LINUX}
  begin
    result := TPath.GetDirectoryName(ParamStr(0));
  end;
{$ENDIF LINUX}
{$IFDEF ANDROID}
  begin
    result := TPath.GetDocumentsPath;
  end;
{$ENDIF ANDROID}

end.
