unit astatobrowseform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, IpHtml, Iphttpbroker, Forms, Controls, Graphics,
  Dialogs, Buttons, ExtCtrls, StdCtrls, lclintf, fphttpclient;

type

  { TBrowsweMainForm }

  TBrowsweMainForm = class(TForm)
    Label1: TLabel;
    SpeedButton3: TSpeedButton;
    status: TLabel;
    SpeedButton2: TSpeedButton;
    url: TEdit;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure urlKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  BrowsweMainForm: TBrowsweMainForm;

implementation

{$R *.lfm}

{ TBrowsweMainForm }


function sendexchangecommandquery(address,port,data:string):string;
 var
   S,rawdata, command: String;

 begin
   result := '';
   With TFPHttpClient.Create(Nil) do
     try
      try
       command := chr(13)+chr(10)+data+chr(13)+chr(10);
       AddHeader('Accept','*/*');
       AddHeader('Content-Type', 'application/json');
       rawdata := Get('http://'+address+':'+port+data);
       //RawData := formpost('http://'+address+':'+port+data,'');
       result := rawdata;
      except
       on E: Exception do result := 'Partner offline: ' + E.Message;
      end
     finally
       free;
     end;
end;


procedure TBrowsweMainForm.FormCreate(Sender: TObject);
begin
  top := 52;
  left := 0;
  width := screen.Width;
end;

procedure TBrowsweMainForm.FormShow(Sender: TObject);
begin
  SpeedButton1Click(nil);
end;

procedure TBrowsweMainForm.SpeedButton1Click(Sender: TObject);
var
  address: string;
  port: string;

function not_suported(ext:string):boolean;
begin
  result := false;
  if ext = '.onion' then
    begin
      status.Font.Color := $8888FF;
      status.Caption := 'Not suported use TOR browser';
      result := true;
    end;
end;

begin
  if (pos('://',url.Text) = 0) then url.text := 'http://'+url.text;
  address := copy(url.text,pos('://',url.text)+3,255);
       if pos(':',address) > 0 then
         begin
           port := copy(address,pos(':',address)+1,255);
           address := copy(address,1,pos(':',address)-1);
         end
       else
         port := '';
  if not_suported(extractfileext(address)) then
      begin
        exit;
      end;

  if pos('.astato.org',url.text) = 0 then
    begin
    if extractfileext(address) = '.astato' then
      begin

       address := 'http://'+sendexchangecommandquery('localhost','8991','/?'+address);

       if port <> '' then address := address;
       try
         status.Font.Color := $FF9999;
         status.caption := 'Net: Astato Network';
         OpenURL(address);
       except

       end;
      end
    else
      begin
        try
          status.Font.Color := cllime;
          status.caption := 'Net: Surface';
          OpenURL(url.text);
        except
        end;
      end;
    end
   else
      begin
        try
          status.caption := 'Net: Surface';
          OpenURL(url.text);
        except
        end;
      end;

end;

procedure TBrowsweMainForm.SpeedButton2Click(Sender: TObject);
begin
  close;
end;

procedure TBrowsweMainForm.SpeedButton3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TBrowsweMainForm.SpeedButton3MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssleft in Shift then
    begin
      top := top+y-8;
    end;
end;

procedure TBrowsweMainForm.urlKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Chr(Key) = #13 Then begin
     SpeedButton1Click(nil);
  end;
end;

end.

