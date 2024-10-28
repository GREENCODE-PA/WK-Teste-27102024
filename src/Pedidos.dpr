program Pedidos;

uses
  Vcl.Forms,
  uPedido in 'uPedido.pas' {frmPedidoVenda},
  uFuncoes in 'uFuncoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPedidoVenda, frmPedidoVenda);
  Application.Run;
end.
