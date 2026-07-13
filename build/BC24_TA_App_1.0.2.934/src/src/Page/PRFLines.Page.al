Page 50850 "PRF Lines"
{
    PageType = Card;
    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type 2" = const(Requisition),
                            "RFQ Created" = const(false),
                            "Document Type" = const(Quote), Status = filter(Released));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(Select; Rec.Select)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Select field.';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(DocumentType2; Rec."Document Type 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Type 2 field.';
                }
                field(RFQNo; Rec."RFQ No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the RFQ No. field.';
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location where the items on the line will be located.';
                }
                field(RFQCreated; Rec."RFQ Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the RFQ Created field.';
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document that you are about to create.';
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line''s number.';
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number.';
                }
                field(ExpectedReceiptDate; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date you expect the items to be available in your warehouse.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the blanket purchase order.';
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the item or resource''s unit of measure, such as piece or hour.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the purchase order line.';
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CreateQuotationLines)
            {
                ApplicationArea = Basic;
                Caption = 'Create Quotation Lines';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Create Quotation Lines action.';

                trigger OnAction()
                begin
                    /*PQLines.RESET;
                    PQLines.SETRANGE(PQLines."Document No.","RFQ No.");
                    IF PQLines.FIND('-') THEN
                    ERROR('The Lines you have selected exist in another RFQ please delete the lines before reselecting again');
                    */// now use  getsrfq
                    Rec.Reset;
                    Rec.SetRange(Select, true);
                    Rec.SETRANGE(Status, Rec.Status::Released);
                    Rec.SetRange("RFQ Created", false);
                    Rec.SetRange("Document Type 2", Rec."document type 2"::Requisition);
                    if Rec.Find('-') then begin
                        repeat
                            PQLines.Init;
                            PQLines."Document Type" := Rec."Document Type";
                            PQLines."Document No." := getsrfq;
                            PQLines."Line No." := Rec."Line No.";
                            PQLines.Type := Rec.Type;
                            PQLines."No." := Rec."No.";
                            PQLines."Location Code" := PQLines."Location Code";
                            PQLines."Expected Receipt Date" := Rec."Expected Receipt Date";
                            PQLines.Description := Rec.Description;
                            PQLines."Unit of Measure" := Rec."Unit of Measure";
                            PQLines.Quantity := Rec.Quantity;
                            PQLines.validate(Quantity);
                            PQLines.Amount := Rec.Amount;
                            PQLines."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                            PQLines."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                            PQLines."Unit Cost" := Rec."Unit Cost";
                            PQLines."Line Amount" := Rec."Line Amount";
                            PQLines."Order Date" := Rec."Order Date";
                            PQLines."Requisition No" := Rec."Document No.";
                            Rec."Line Created" := true;
                            PQLines.Insert;
                            Rec."RFQ No." := getsrfq;
                            Rec.Modify;
                        until Rec.Next = 0;
                    end;

                    if Confirm('All Lines Successfully Selected, Exit Window?', true) = true then begin
                        CurrPage.Close();



                    end;

                end;
            }
        }
    }

    var
        PQLines: Record "Purchase Quote Line";
        getsrfq: Code[20];

    procedure GetRFQ(RFQ: Code[20])
    begin
        getsrfq := RFQ;
    end;
}

