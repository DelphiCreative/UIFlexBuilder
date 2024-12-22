unit uMainFlex;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  System.ImageList, FMX.ImgList, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.MultiResBitmap,FMX.Objects, FMX.TabControl, FMX.Ani, FMX.Effects;

type
  TfrmMain = class(TForm)
    ImageList1: TImageList;
    Rectangle1: TRectangle;
    StyleBook1: TStyleBook;
    flwButtons: TFlowLayout;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    flwMain: TFlowLayout;
    flwOthers: TFlowLayout;
    ShadowEffect1: TShadowEffect;
    Rectangle2: TRectangle;
    ShadowEffect2: TShadowEffect;
    VertScrollBox1: TVertScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function FindBitmapByName(const AName: string): TBitmap;
    procedure FormContact;
    procedure SaveContact;
    procedure SaveClick(Sender: TObject);
    procedure MenuClick(Sender: TObject);
end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses FMX.UIFlexBuilder, dMain;

var FormBuilder :TUIFlexBuilder;

procedure TfrmMain.FormContact;
begin
   if Assigned(FormBuilder) then
      FormBuilder.Free;

   FormBuilder := TUIFlexBuilder.Create(Self, flwMain);
   FormBuilder.DataSet := dmMain.FDQuery1;
   FormBuilder.KeyField := 'id';

   FormBuilder
     .AddTextField('Dados do cliente')
     .AddEditField('id', 'Código')
     .AddEditField('nome', 'Nome', 'Nome é um campo obrigatório' ,348)
     .AddEditField('documento', 'Cpf:','XXX.XXX.XXX-XX', 0, fmtCPF);

   FormBuilder
      .AddTextField('Dados de endereço')
      .AddEditField('cep', 'Cep', fmtCEP)
      .AddEditField('rua', 'Rua')
        .SetTextPrompt('Informe o endereco')
        .SetWidth(348)
      .AddEditField('numero', 'Nº')
      .LineBreak;

   FormBuilder
      .AddEditField('complemento', 'Complemento', 'Casa/Apart.')
      .AddEditField('bairro', 'Bairro',261)
      .AddEditField('cidade', 'Cidade',261)
      .SetFieldSize(fsSmall)
      .AddTextField('')
      .AddTextField('')
      .AddSpace(520)
      .SetButtonColor(TAlphaColors.Ghostwhite,TAlphaColors.Darkgrey)
      .SetButtonTextColor(TAlphaColors.Darkgrey,TAlphaColors.Ghostwhite)
      .AddButton('Outras informações >>', MenuClick)
      ;

   FormBuilder
      .InParent(flwOthers)
      .SetFieldSize(fsNormal)
      .AddTextField('Dados de contato')
      .AddEditField('telefone', 'Telefone',fmtPhone)
      .AddEditField('telefone2', 'Telefone 2', fmtPhone)
      .AddEditField('email', 'E-Mail','cliente@email.com',348);

   FormBuilder
      .AddTextField('Outras informações')
      .AddEditField('data_nasc', 'Data de Nascimento','dd/mm/aaaa', 0, fmtDate)
      .AddEditField('data_cadastro', 'Data de Cadastro','dd/mm/aaaa', 0, fmtDate)
      .AddComboBoxField('sexo', 'Sexo', ['Masculino', 'Feminino', 'Outros'])
      .AddEditField('limite', 'Limite', '0,00', 167, fmtDecimal )
      .LineBreak
      .AddMemoField('anotacoes', 'Anotações', 700)
      .SetFieldSize(fsSmall)
      .AddButton('<< Dados gerais', MenuClick);

   FormBuilder
      .LineBreak
      .SetFieldSize(fsSmall)
      .SetButtonColor(TAlphaColors.Darkblue)
      .SetButtonTextColor(TAlphaColors.Ghostwhite)
      .ApplyDefaultWidth(120)
      .InParent(flwButtons)
      .AddButton('Salvar', SaveClick)
          .AddIcon(FindBitmapByName('Item 6'), 30)
      .AddButton('Cancelar', btClearFields)
          .AddIcon(FindBitmapByName('Item 0'), 22)
      .AddButton('Excluir', btDelete)
          .AddIcon(FindBitmapByName('Item 0'), 25)
      ;
   FormBuilder
      .AddSpace(110)
      .ApplyDefaultWidth(50)
      .AddButton('<<', btFirst)
      .AddButton('<', btPrior)
      .AddButton('>', btNext)
      .AddButton('>>', btLast);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var fxMenu : TUIFlexBuilder;
begin

   dmMain.FDQuery1.Open('SELECT * FROM contatos');

   fxMenu := TUIFlexBuilder.Create(Self, VertScrollBox1);

   fxMenu
      .SetButtonColor(TAlphaColors.Ghostwhite,TAlphaColors.Darkgrey)
      .SetButtonTextColor(TAlphaColors.Darkgrey,TAlphaColors.Ghostwhite)

      .AddTextField('Menu UIFlexBuilder')
      .SetFieldSize(fsSmall)

      .AddTextField('Cadastro')
         .AddButton('Clientes')
            .AddIcon(FindBitmapByName('Item 0'))
         .AddButton('Fornecedores')
            .AddIcon(FindBitmapByName('Item 1'))

      .AddTextField('Movimentos')
         .AddButton('Contas à pagar')
            .AddIcon(FindBitmapByName('Item 2'))
         .AddButton('Contas à receber')
            .AddIcon(FindBitmapByName('Item 3'))
         .AddButton('Pedido')
            .AddIcon(FindBitmapByName('Item 6'))

      .AddTextField('Relatórios')
         .AddButton('Clientes')
            .AddIcon(FindBitmapByName('Item 7'))
         .AddButton('Fornecedores')
            .AddIcon(FindBitmapByName('Item 10'));

   fxMenu.Free;
   FormContact;
end;

procedure TfrmMain.SaveClick(Sender: TObject);
begin
  SaveContact;
end;

procedure TfrmMain.SaveContact;
var
  Result : TValidationResult;
begin

  Result := FormBuilder
               .SetErrorColor(TAlphaColors.Lightpink)
               .NotEmpty('nome')
               .LengthBetween('nome',5, 100)
               .NotEmpty('rua')
               .IsMatchesRegex('email', '^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$')
               .NotEmpty('data_nasc')
               .IsDate('data_nasc')
               .Validate;

  if not Result.IsValid then begin
     TUIFlexMessageBox.ShowMessage('Aviso', String.Join(sLineBreak, Result.Errors), ['OK']);
     abort;
  end;

  FormBuilder.PopulateDataSetFromFields;
  FormBuilder.DataSetPost;

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FormBuilder) then
      FormBuilder.Free;
end;

procedure TfrmMain.MenuClick(Sender: TObject);
begin
   if TFlexButton(Sender).Value = 'Outras informações >>'  then
      TabControl1.GotoVisibleTab(1, TTabTransition.Slide)
   else
      TabControl1.GotoVisibleTab(0, TTabTransition.Slide)

end;

function TfrmMain.FindBitmapByName(const AName: string): TBitmap;
var
  Item: TCustomBitmapItem;
  Size: TSize;
begin
  if ImageList1.BitmapItemByName(AName, Item, Size) then
     Result := Item.MultiResBitmap.Bitmaps[1.0]
  else
     Result := nil;
end;

initialization
   ReportMemoryLeaksOnShutdown := True;

end.
