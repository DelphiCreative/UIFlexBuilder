unit dMain;

interface

uses

  System.IOUtils, System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TdmMain = class(TDataModule)
    FDQuery1: TFDQuery;
    Sqlite: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateDatabase;
  end;

var
  dmMain: TdmMain;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses DC.Firedac.VersionControl;

{$R *.dfm}

procedure TdmMain.DataModuleCreate(Sender: TObject);
var
   DatabaseFilePath: string;
begin
   DatabaseFilePath := TPath.Combine( DatabaseFilePath, 'DB');
   ForceDirectories(DatabaseFilePath);
   Sqlite.Params.Database :=  TPath.Combine( DatabaseFilePath, 'FlexBuilder.db');
   Sqlite.Connected := True;
   UpdateDatabase;
end;

procedure TdmMain.UpdateDatabase;
var
   VersionControl: TDCFiredacVersionControl;
begin
   VersionControl := TDCFiredacVersionControl.Create(Sqlite);
   try
      // Adiciona scripts de versão ao MemTable
     VersionControl.AddScript(1, 'Criação da tabela de contatos',
                                '''
                                CREATE TABLE IF NOT EXISTS contatos (
                                id INTEGER PRIMARY KEY AUTOINCREMENT,
                                nome VARCHAR(100) NOT NULL,
                                documento VARCHAR(14) NOT NULL,                                -- Para CPF no formato XXX.XXX.XXX-XX
                                cep VARCHAR(9),                                                -- Para CEP no formato XXXXX-XXX
                                rua VARCHAR(100),
                                numero VARCHAR(10),
                                complemento VARCHAR(50),
                                bairro VARCHAR(100),
                                cidade VARCHAR(50),
                                telefone VARCHAR(15),                                          -- Para telefone com formato (XX) XXXXX-XXXX
                                telefone2 VARCHAR(15),
                                email VARCHAR(100),
                                data_nasc DATE,                                                -- Data de nascimento
                                data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,             -- Data de cadastro com valor padrão de data/hora atual
                                sexo TEXT CHECK (sexo IN ('Masculino', 'Feminino', 'Outros')), -- Limita valores a estas opções
                                limite DECIMAL(15, 2) DEFAULT 0.00,                            -- Valor decimal para limite
                                anotacoes TEXT                                                 -- Texto longo para anotações
                                );
                            ''' );

      // Executa os scripts
      VersionControl.ExecuteVersionedScripts;
   finally
      VersionControl.Free;
   end;
end;


end.
