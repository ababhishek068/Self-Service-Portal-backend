page 51377 "Purchase Quote Request Line"
{
    PageType = ListPart;
    SourceTable = "Purchase Quote Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
                field(Description; Rec.Description)
                {
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Line Amount field.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
            }
        }
    }

    actions { }


    var
        PurchQHeader: Record "Purchase Quote Header";

    procedure getLineNo(): Integer
    begin
        exit(Rec."Line No.");
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        if Rec."Document No." <> '' then begin
            PurchQHeader.Reset;
            PurchQHeader.SetRange(PurchQHeader."Document Type", Rec."Document Type");
            PurchQHeader.SetRange(PurchQHeader."No.", Rec."No.");
            if PurchQHeader.Status = PurchQHeader.Status::Open then begin
                CurrPage.Editable := true;
            end
            else begin
                CurrPage.Editable := false;
            end;
        end;
    end;
}

