unit uPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.IniFiles;

type
  TfrmPedidoVenda = class(TForm)
    pnlTopo: TPanel;
    pnlRodape: TPanel;
    pnlCentral: TPanel;
    edtCodCliente: TEdit;
    lblCliente: TLabel;
    edtNomeCliente: TEdit;
    edtCodProduto: TEdit;
    lblProduto: TLabel;
    edtDescProduto: TEdit;
    edtQuantidade: TEdit;
    lblQuantidade: TLabel;
    edtValorUnitario: TEdit;
    lblValorUnitario: TLabel;
    btnSalvaProduto: TButton;
    grdProdutos: TStringGrid;
    lblTotal: TLabel;
    edtTotal: TEdit;
    btnGravar: TButton;
    FDConexao: TFDConnection;
    qryClientes: TFDQuery;
    qryProdutos: TFDQuery;
    qryPedidos: TFDQuery;
    qryPedidosProdutos: TFDQuery;
    FDDriverLink: TFDPhysMySQLDriverLink;
    btnCancelarPedido: TButton;
    btnCarregarPedido: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSalvaProdutoClick(Sender: TObject);
    procedure grdProdutosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCarregarPedidoClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure edtCodClienteExit(Sender: TObject);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure edtQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure edtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure edtQuantidadeEnter(Sender: TObject);
  private
    procedure ConfigurarConexao;
    procedure ConfigurarGrid;
    procedure ConfiguraBotoes;
    procedure AtualizaProdutoPedido(Linha: Integer);
    procedure AtualizarTotalPedido;
    procedure LimparCamposProduto;
    procedure EditarProdutoPedido;
    procedure ExcluirProdutoPedido;
    procedure CarregarPedido(NumeroPedido: Integer);
    function ValidarDados: Boolean;
    procedure GravarPedido;
   public
  end;

var
  frmPedidoVenda: TfrmPedidoVenda;

implementation

{$R *.dfm}

uses uFuncoes;


{ TfrmPedidoVenda }

procedure TfrmPedidoVenda.ConfigurarConexao;
var
  IniFile: TIniFile;
  sLibName, sLibPath: string;
begin
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    try
      FDConexao.Params.Clear;
      FDConexao.Params.DriverID := 'MySQL';
      FDConexao.Params.Database := IniFile.ReadString('Database', 'Database', 'pedidosDB');
      FDConexao.Params.UserName := IniFile.ReadString('Database', 'Username', 'SYSDBA');
      FDConexao.Params.Password := IniFile.ReadString('Database', 'Password', '12345');
      FDConexao.Params.Values['Server'] := IniFile.ReadString('Database', 'Server', '127.0.0.1');
      FDConexao.Params.Values['Port'] := IniFile.ReadString('Database', 'Port', '3306');

      sLibName := IniFile.ReadString('Database', 'LibraryName', 'libmysql.dll');
      FDConexao.Params.Values['LibraryName'] := sLibName;

      sLibPath := IniFile.ReadString('Database', 'LibraryPath', '');
      if sLibPath.trim='' then
        sLibPath := extractFilePath( application.ExeName );
      FDConexao.Params.Values['LibraryPath'] := IncludeTrailingPathDelimiter(sLibPath)+sLibName;

      FDConexao.Connected := True;
    except
      on e: exception do
      begin
        showMessage('Falha ao Configurar a Conexão'+#13#13+e.message);
        halt;
      end;
    end;
  finally
    IniFile.Free;
  end;
end;

procedure TfrmPedidoVenda.ConfigurarGrid;
begin
  with grdProdutos do
  begin
    ColCount := 5;
    RowCount := 2;
    FixedRows := 1;
    Cells[0, 0] := 'Código';
    Cells[1, 0] := 'Descrição';
    Cells[2, 0] := 'Quantidade';
    Cells[3, 0] := 'Vlr. Unitário';
    Cells[4, 0] := 'Vlr. Total';
    ColWidths[0] := 80;
    ColWidths[1] := 250;
    ColWidths[2] := 100;
    ColWidths[3] := 100;
    ColWidths[4] := 100;
  end;
end;

procedure TfrmPedidoVenda.LimparCamposProduto;
begin
  edtCodProduto.clear;
  edtDescProduto.clear;
  edtQuantidade.Clear;
  edtValorUnitario.Clear;
  btnSalvaProduto.Caption := 'Inserir';
  btnSalvaProduto.Tag := 0;
end;

procedure TfrmPedidoVenda.FormCreate(Sender: TObject);
begin
  FormatSettings.ThousandSeparator := '.';
  FormatSettings.DecimalSeparator := ',';
  ConfigurarConexao;
  ConfigurarGrid;
  LimparCamposProduto;
  ConfiguraBotoes;
end;

procedure TfrmPedidoVenda.ConfiguraBotoes;
begin
  btnCarregarPedido.Visible := trim(edtCodCliente.Text) = '';
  btnCancelarPedido.Visible := trim(edtCodCliente.Text) = '';
end;

procedure TfrmPedidoVenda.edtCodClienteExit(Sender: TObject);
begin
  ConfiguraBotoes;
  if trim(edtCodCliente.Text) = '' then
    Exit;

  qryClientes.Close;
  qryClientes.SQL.Text := 'SELECT nome FROM clientes WHERE codigo = :codigo';
  qryClientes.ParamByName('codigo').AsInteger := StrToIntDef(edtCodCliente.Text, 0);
  qryClientes.Open;

  if not qryClientes.IsEmpty then
  begin
    edtNomeCliente.Text := qryClientes.FieldByName('nome').AsString;
    edtCodProduto.setfocus;
  end
  else
  begin
    ShowMessage('Cliente não encontrado!');
    edtCodCliente.SetFocus;
  end
end;

procedure TfrmPedidoVenda.edtCodProdutoExit(Sender: TObject);
begin
  if edtCodProduto.Text = '' then
    Exit;

  qryProdutos.Close;
  qryProdutos.SQL.Text := 'SELECT descricao, preco_venda FROM produtos WHERE codigo = :codigo';
  qryProdutos.ParamByName('codigo').AsInteger := StrToIntDef(edtCodProduto.Text, 0);
  qryProdutos.Open;

  if not qryProdutos.IsEmpty then
  begin
    edtDescProduto.Text := qryProdutos.FieldByName('descricao').AsString;
    edtValorUnitario.Text := FormatFloat('#,##0.00', qryProdutos.FieldByName('preco_venda').AsFloat);
    edtQuantidade.SetFocus;
  end
  else
  begin
    ShowMessage('Produto não encontrado!');
    edtCodProduto.SetFocus;
  end;
end;

procedure TfrmPedidoVenda.edtQuantidadeEnter(Sender: TObject);
begin
  if StrToFloatDef(edtQuantidade.Text,0)=0 then
     edtQuantidade.Text:= '1';
end;

procedure TfrmPedidoVenda.edtQuantidadeKeyPress(Sender: TObject; var Key: Char);
begin
  Key := SomenteNumeros(key, true);
end;

procedure TfrmPedidoVenda.edtValorUnitarioKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := SomenteNumeros(key, true);
end;

procedure TfrmPedidoVenda.btnSalvaProdutoClick(Sender: TObject);
var
  LinhaAtual: integer;
begin
  if trim(edtCodProduto.Text) = '' then
    exit;
  if btnSalvaProduto.Tag = 0 then //inserir
    AtualizaProdutoPedido(0)
  else
  begin
    LinhaAtual := grdProdutos.Row;
    if (LinhaAtual > 0) and (grdProdutos.Cells[0, LinhaAtual] <> '') then
      AtualizaProdutoPedido(LinhaAtual);
  end;
end;

procedure TfrmPedidoVenda.AtualizaProdutoPedido(Linha: Integer);
var
  qtd, vlrU, vlrT: Currency;
begin
  qtd := StringToFloatDef( edtQuantidade.Text,-1) ;
  vlrU := StringToFloatDef( edtValorUnitario.Text,-1) ;

  if (qtd<=0) or (vlrU<=0)  then
  begin
    showmessage('Quantidade ou Valor Unitário: Dado Inválido ou Não Informado.');
    edtQuantidade.setFocus;
    exit;
  end;

  vlrT := qtd*vlrU;

  if Linha=0 then
  begin
    Linha := grdProdutos.RowCount-1 ;
    grdProdutos.RowCount := grdProdutos.RowCount + 1;
  end;

  grdProdutos.Cells[0, Linha] := edtCodProduto.Text;
  grdProdutos.Cells[1, Linha] := edtDescProduto.Text;
  grdProdutos.Cells[2, Linha] := FormatFloat('#,##0.00', qtd );
  grdProdutos.Cells[3, Linha] := FormatFloat('#,##0.00', vlrU );
  grdProdutos.Cells[4, Linha] := FormatFloat('#,##0.00', vlrT );

  AtualizarTotalPedido;
  LimparCamposProduto;

  edtCodProduto.SetFocus;
end;

procedure TfrmPedidoVenda.AtualizarTotalPedido;
var
  I: Integer;
  Total: Double;
begin
  Total := 0;
  for I := 1 to grdProdutos.RowCount - 1 do
    Total := Total + StrToFloatDef(StringReplace(grdProdutos.Cells[4, I], '.', '', []), 0);
  edtTotal.Text := FormatFloat('#,##0.00', Total);
end;

procedure TfrmPedidoVenda.EditarProdutoPedido;
var
  Linha: Integer;
begin
  Linha := grdProdutos.Row;
  edtCodProduto.Text := grdProdutos.Cells[0, Linha];
  edtDescProduto.Text := grdProdutos.Cells[1, Linha];
  edtQuantidade.Text := grdProdutos.Cells[2, Linha];
  edtValorUnitario.Text := grdProdutos.Cells[3, Linha];
  btnSalvaProduto.Caption := 'Alterar';
  btnSalvaProduto.Tag := 1;
  edtQuantidade.SetFocus;
end;

procedure TfrmPedidoVenda.grdProdutosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN: begin
      Key := 0;
      if (grdProdutos.Row > 0) then
        EditarProdutoPedido;
    end;
    VK_DELETE: begin
      Key := 0;
      if grdProdutos.Row > 0 then
        ExcluirProdutoPedido;
    end;
  end;
end;

procedure TfrmPedidoVenda.ExcluirProdutoPedido;
var
  Linha: Integer;
begin
  if (grdProdutos.cells[0,linha]<>'')  then
    if MessageDlg('Deseja realmente excluir este produto?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Linha := grdProdutos.Row;
      while Linha < grdProdutos.RowCount - 1 do
      begin
        grdProdutos.Rows[Linha].Assign(grdProdutos.Rows[Linha + 1]);
        Inc(Linha);
      end;
      grdProdutos.RowCount := grdProdutos.RowCount - 1;
      AtualizarTotalPedido;
    end;
end;

procedure TfrmPedidoVenda.btnGravarClick(Sender: TObject);
begin
  if ValidarDados then
    GravarPedido;
end;

procedure TfrmPedidoVenda.btnCarregarPedidoClick(Sender: TObject);
var
  NumeroPedidoStr: string;
begin
  if InputQuery('Carregar Pedido', 'Digite o número do pedido:', NumeroPedidoStr) then
  begin
    if StrToIntDef(NumeroPedidoStr, 0)<=0 then
      ShowMessage('Número do Pedido: Inválido ou Não Informado!')
    else
      CarregarPedido(NumeroPedidoStr.toInteger);
  end;
end;

procedure TfrmPedidoVenda.CarregarPedido(NumeroPedido: Integer);
var
  I: Integer;
begin
  try
    // Buscar pedido
    qryPedidos.Close;
    qryPedidos.SQL.Text := 'SELECT p.*, c.nome FROM pedidos p ' +
                           'INNER JOIN clientes c ON c.codigo = p.codigo_cliente ' +
                           'WHERE p.numero_pedido = :numero';
    qryPedidos.ParamByName('numero').AsInteger := NumeroPedido;
    qryPedidos.Open;

    if qryPedidos.IsEmpty then
    begin
      ShowMessage('Pedido não encontrado!');
      Exit;
    end;

    // cliente
    edtCodCliente.Text := qryPedidos.FieldByName('codigo_cliente').AsString;
    edtNomeCliente.Text := qryPedidos.FieldByName('nome').AsString;
    edtTotal.Text := FormatFloat('#,##0.00', qryPedidos.FieldByName('valor_total').AsFloat);

    // produtos
    qryPedidosProdutos.Close;
    qryPedidosProdutos.SQL.Text := 'SELECT pp.*, p.descricao FROM pedidos_produtos pp ' +
                                   'INNER JOIN produtos p ON p.codigo = pp.codigo_produto ' +
                                   'WHERE pp.numero_pedido = :numero order by id';
    qryPedidosProdutos.ParamByName('numero').AsInteger := NumeroPedido;
    qryPedidosProdutos.Open;

    grdProdutos.RowCount := 2;
    for I := 0 to grdProdutos.ColCount - 1 do
      grdProdutos.Cells[I, 1] := '';
    I := 1;
    while not qryPedidosProdutos.Eof do
    begin
      if I > 1 then
        grdProdutos.RowCount := grdProdutos.RowCount + 1;

      grdProdutos.Cells[0, I] := qryPedidosProdutos.FieldByName('codigo_produto').AsString;
      grdProdutos.Cells[1, I] := qryPedidosProdutos.FieldByName('descricao').AsString;

      grdProdutos.Cells[2, I] := FormatFloat('#,##0.00', qryPedidosProdutos.FieldByName('quantidade').AsFloat );
      grdProdutos.Cells[3, I] := FormatFloat('#,##0.00', qryPedidosProdutos.FieldByName('valor_unitario').AsFloat );
      grdProdutos.Cells[4, I] := FormatFloat('#,##0.00', qryPedidosProdutos.FieldByName('valor_total').AsFloat );

      Inc(I);
      qryPedidosProdutos.Next;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao carregar pedido: ' + E.Message);
  end;
end;

procedure TfrmPedidoVenda.btnCancelarPedidoClick(Sender: TObject);
var
  NumeroPedidoStr: string;
begin
  if InputQuery('Cancelar Pedido', 'Digite o número do pedido:', NumeroPedidoStr) then
  begin
    if StrToIntDef(NumeroPedidoStr, 0)<=0 then
      ShowMessage('Número do Pedido: Inválido ou Não Informado!')
    else
    begin
      try
        // pedido a cancelar
        qryPedidos.Close;
        qryPedidos.SQL.Text := 'SELECT numero_pedido FROM pedidos WHERE numero_pedido = :numero';
        qryPedidos.ParamByName('numero').AsInteger := NumeroPedidoStr.ToInteger;
        qryPedidos.Open;

        if qryPedidos.IsEmpty then
        begin
          ShowMessage('Pedido não encontrado!');
          Exit;
        end;

        if MessageDlg('Confirma o cancelamento do pedido ' + NumeroPedidoStr + '?',
          mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          try
            FDConexao.StartTransaction;

            // exclui os produtos
            qryPedidosProdutos.Close;
            qryPedidosProdutos.SQL.Text := 'DELETE FROM pedidos_produtos WHERE numero_pedido = :numero';
            qryPedidosProdutos.ParamByName('numero').AsInteger := NumeroPedidoStr.toInteger;
            qryPedidosProdutos.ExecSQL;

            // exclui o pedido
            qryPedidos.Close;
            qryPedidos.SQL.Text := 'DELETE FROM pedidos WHERE numero_pedido = :numero';
            qryPedidos.ParamByName('numero').AsInteger := NumeroPedidoStr.toInteger;
            qryPedidos.ExecSQL;

            FDConexao.Commit;
            ShowMessage('Pedido cancelado com sucesso!');
          except
            on E: Exception do
            begin
              FDConexao.Rollback;
              raise Exception.Create('Erro ao cancelar pedido: ' + E.Message);
            end;
          end;
        end;
      except
        on E: Exception do
          ShowMessage(E.Message);
      end;
    end;
  end;
end;

function TfrmPedidoVenda.ValidarDados: Boolean;
begin
  Result := False;

  if trim(edtCodCliente.Text) = '' then
  begin
    ShowMessage('Cliente não informado!');
    edtCodCliente.SetFocus;
    Exit;
  end;

  if trim(grdProdutos.Cells[0, 1]) = '' then
  begin
    ShowMessage('Nenhum produto informado!');
    edtCodProduto.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmPedidoVenda.GravarPedido;
var
  I: Integer;
begin
  if not ValidarDados then Exit;

  try
    FDConexao.StartTransaction;

    // Grava cabeçalho do pedido
    qryPedidos.Close;
    qryPedidos.SQL.Text := 'INSERT INTO pedidos (data_emissao, codigo_cliente, valor_total) ' +
                           'VALUES (:data, :cliente, :total)';
    qryPedidos.ParamByName('data').AsDate := Date;
    qryPedidos.ParamByName('cliente').AsInteger := StrToInt(edtCodCliente.Text);
    qryPedidos.ParamByName('total').AsFloat := StrToFloat(StringReplace(edtTotal.Text, '.', '', []));
    qryPedidos.ExecSQL;

    // Obtém o número do pedido gerado
    qryPedidos.SQL.Text := 'SELECT LAST_INSERT_ID() as numero';
    qryPedidos.Open;

    // Grava itens do pedido
    for I := 1 to grdProdutos.RowCount - 2 do
    begin
      qryPedidosProdutos.Close;
      qryPedidosProdutos.SQL.Text := 'INSERT INTO pedidos_produtos ' +
        '(numero_pedido, codigo_produto, quantidade, valor_unitario, valor_total) ' +
        'VALUES (:pedido, :produto, :qtd, :unitario, :total)';
      qryPedidosProdutos.ParamByName('pedido').AsInteger := qryPedidos.FieldByName('numero').AsInteger;
      qryPedidosProdutos.ParamByName('produto').AsInteger := StrToInt(grdProdutos.Cells[0, I]);
      qryPedidosProdutos.ParamByName('qtd').AsFloat := StrToFloat(grdProdutos.Cells[2, I]);
      qryPedidosProdutos.ParamByName('unitario').AsFloat := StrToFloat(StringReplace(grdProdutos.Cells[3, I], '.', '', []));
      qryPedidosProdutos.ParamByName('total').AsFloat := StrToFloat(StringReplace(grdProdutos.Cells[4, I], '.', '', []));
      qryPedidosProdutos.ExecSQL;
    end;

    FDConexao.Commit;
    ShowMessage('Pedido gravado com sucesso!');

    edtCodCliente.Clear;
    edtNomeCliente.Clear;
    LimparCamposProduto;
    ConfiguraBotoes;

    grdProdutos.RowCount := 2;
    for I := 0 to grdProdutos.ColCount - 1 do
      grdProdutos.Cells[I, 1] := '';
    edtTotal.Text := '0,00';

  except
    on E: Exception do
    begin
      FDConexao.Rollback;
      ShowMessage('Erro ao gravar pedido: ' + E.Message);
    end;
  end;
end;

end.
