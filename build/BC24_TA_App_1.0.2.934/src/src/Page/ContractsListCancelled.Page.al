page 50251 "Contracts List - Cancelled"
{
    Caption = 'Cancelled  Contracts';
    CardPageID = "Contract Card";
    Editable = false;
    PageType = List;
    SourceTable = Contract;
    SourceTableView = WHERE(Status = FILTER('Cancelled'));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract Reference No"; Rec."Contract Reference No")
                {
                    ToolTip = 'Specifies the value of the Contract Reference No field.';
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field("Contractor No."; Rec."Contractor No.")
                {
                    ToolTip = 'Specifies the value of the Contractor No. field.';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Expiry Date field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Requested By"; Rec."Requested By")
                {
                    ToolTip = 'Specifies the value of the Requested By field.';
                }
            }
        }
    }

    actions { }

    trigger OnInit()
    begin
        Window.OPEN('Refreshing Cancelled Contracts');
        Contracts.RESET;
        Contracts.SETRANGE(Contracts.Status, Contracts.Status::Cancelled);
        IF Contracts.FIND('-') THEN BEGIN
            REPEAT
                IF Contracts."Expiry Date" < TODAY THEN BEGIN
                    Contracts.Active := FALSE;
                    Contracts."Contract Status" := Contracts."Contract Status"::Cancelled;
                    Contracts.MODIFY;
                END;
            UNTIL Contracts.NEXT = 0;
        END;
        Window.CLOSE;
        CurrPage.UPDATE();
    end;

    var
        Window: Dialog;
        Contracts: Record Contract;
}

