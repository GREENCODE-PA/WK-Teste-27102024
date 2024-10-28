object frmPedidoVenda: TfrmPedidoVenda
  Left = 0
  Top = 0
  Caption = 'Pedido de Venda'
  ClientHeight = 561
  ClientWidth = 794
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 794
    Height = 121
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 790
    object lblCliente: TLabel
      Left = 16
      Top = 16
      Width = 40
      Height = 15
      Caption = 'Cliente:'
    end
    object lblProduto: TLabel
      Left = 16
      Top = 64
      Width = 46
      Height = 15
      Caption = 'Produto:'
    end
    object lblQuantidade: TLabel
      Left = 347
      Top = 64
      Width = 65
      Height = 15
      Caption = 'Quantidade:'
    end
    object lblValorUnitario: TLabel
      Left = 418
      Top = 64
      Width = 74
      Height = 15
      Caption = 'Valor Unit'#225'rio:'
    end
    object edtCodCliente: TEdit
      Left = 16
      Top = 32
      Width = 60
      Height = 23
      NumbersOnly = True
      TabOrder = 0
      OnExit = edtCodClienteExit
    end
    object edtNomeCliente: TEdit
      Left = 82
      Top = 32
      Width = 503
      Height = 23
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object edtCodProduto: TEdit
      Left = 16
      Top = 80
      Width = 60
      Height = 23
      NumbersOnly = True
      TabOrder = 2
      OnExit = edtCodProdutoExit
    end
    object edtDescProduto: TEdit
      Left = 82
      Top = 80
      Width = 259
      Height = 23
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
    object edtQuantidade: TEdit
      Left = 347
      Top = 80
      Width = 60
      Height = 23
      Alignment = taRightJustify
      TabOrder = 4
      OnEnter = edtQuantidadeEnter
      OnKeyPress = edtQuantidadeKeyPress
    end
    object edtValorUnitario: TEdit
      Left = 418
      Top = 80
      Width = 89
      Height = 23
      Alignment = taRightJustify
      TabOrder = 5
      OnKeyPress = edtValorUnitarioKeyPress
    end
    object btnSalvaProduto: TButton
      Left = 528
      Top = 79
      Width = 57
      Height = 25
      Caption = 'Inserir'
      TabOrder = 6
      OnClick = btnSalvaProdutoClick
    end
    object btnCancelarPedido: TButton
      Left = 618
      Top = 60
      Width = 143
      Height = 25
      Caption = 'Cancelar Pedido'
      TabOrder = 7
      OnClick = btnCancelarPedidoClick
    end
    object btnCarregarPedido: TButton
      Left = 618
      Top = 29
      Width = 143
      Height = 25
      Caption = 'Carregar Pedido'
      TabOrder = 8
      OnClick = btnCarregarPedidoClick
    end
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 520
    Width = 794
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 519
    ExplicitWidth = 790
    object lblTotal: TLabel
      Left = 528
      Top = 14
      Width = 57
      Height = 15
      Caption = 'Valor Total:'
    end
    object btnGravar: TButton
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Gravar'
      TabOrder = 0
      OnClick = btnGravarClick
    end
    object edtTotal: TEdit
      Left = 591
      Top = 6
      Width = 180
      Height = 23
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = '0,00'
    end
  end
  object pnlCentral: TPanel
    Left = 0
    Top = 121
    Width = 794
    Height = 399
    Align = alClient
    TabOrder = 2
    ExplicitWidth = 790
    ExplicitHeight = 398
    object grdProdutos: TStringGrid
      Left = 1
      Top = 1
      Width = 792
      Height = 397
      Align = alClient
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      TabOrder = 0
      OnKeyDown = grdProdutosKeyDown
      ExplicitWidth = 788
      ExplicitHeight = 396
    end
  end
  object FDConexao: TFDConnection
    Params.Strings = (
      'Database=pedidosDB'
      'User_Name=root'
      'Password=1234'
      'Server=localhost'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 48
    Top = 200
  end
  object qryClientes: TFDQuery
    Connection = FDConexao
    Left = 144
    Top = 200
  end
  object qryProdutos: TFDQuery
    Connection = FDConexao
    Left = 232
    Top = 200
  end
  object qryPedidos: TFDQuery
    Connection = FDConexao
    Left = 320
    Top = 200
  end
  object qryPedidosProdutos: TFDQuery
    Connection = FDConexao
    Left = 424
    Top = 200
  end
  object FDDriverLink: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Users\Usu'#225'rio\Desktop\Adriano\WKSistemas\bin32\LIBMYSQL.DLL'
    Left = 56
    Top = 265
  end
end
