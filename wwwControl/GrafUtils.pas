unit GrafUtils;

interface

uses Windows, Forms, SysUtils, ComCtrls, Classes, GraphicEx,
     ExtCtrls, jpeg, Graphics, Controls, RxGIF;

const
 CRLF = #13+#10;

procedure LoadImageFromFile(const FileName: String; DestImage: TImage);
procedure LoadImageFromStream(AStream: TMemoryStream; DestImage: TImage);


implementation

procedure LoadImageFromStream(AStream: TMemoryStream; DestImage: TImage);
var
  GraphicClass: TGraphicExGraphicClass;
  Graphic: TGraphic;
  Code: Word;
begin
  Screen.Cursor := crHourGlass;
  try
    try
      // determine true file type from content rather than extension
     AStream.Position := 0;
     GraphicClass := FileFormatList.GraphicFromContent(AStream);
     if GraphicClass = nil then begin
       AStream.Position := 0;
       AStream.Read(Code, SizeOf(Code));
       AStream.Seek(0, 0);
       case Code of
         $4D42: begin
            DestImage.Picture.Graphic := TBitmap.Create;
            DestImage.Picture.Graphic.LoadFromStream(AStream);
         end;
         $D8FF: begin
            DestImage.Picture.Graphic := TJPEGImage.Create;
            DestImage.Picture.Graphic.LoadFromStream(AStream);
         end;
         $4947: begin
            DestImage.Picture.Graphic := TGIFImage.Create;
            DestImage.Picture.Graphic.LoadFromStream(AStream);
         end;
         else begin
            DestImage.Picture.Graphic := TJPEGImage.Create;
            DestImage.Picture.Graphic.LoadFromStream(AStream);
         end;
      end;
     end
     else begin
        Graphic := GraphicClass.Create;
        Graphic.LoadFromStream(AStream);
        DestImage.Picture.Graphic := Graphic;
     end;
    except
      raise;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure LoadImageFromFile(const FileName: String; DestImage: TImage);
var
  GraphicClass: TGraphicExGraphicClass;
  Graphic: TGraphic;
begin
  Screen.Cursor := crHourGlass;
  try
    try
      // determine true file type from content rather than extension
      GraphicClass := FileFormatList.GraphicFromContent(FileName);
      if GraphicClass = nil then DestImage.Picture.LoadFromFile(FileName)
                            else
      begin
        // GraphicFromContent always returns TGraphicExGraphicClass
        Graphic := GraphicClass.Create;
        Graphic.LoadFromFile(FileName);
        DestImage.Picture.Graphic := Graphic;
        //DestImage.Picture.Graphic.SaveToFile('!dbl.gif!');
      end;
    except
      raise;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;


end.