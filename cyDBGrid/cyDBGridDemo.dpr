program cyDBGridDemo;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  cyDBGrid in 'cyDBGrid.pas',
  cyBookmarkList in 'cyBookmarkList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
