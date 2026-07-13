Page 50126 "Contracts Card"
{
    PageType = Card;
    SourceTable = Contracts;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Contract No"; Rec."Contract No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract No field.';
                }
                field(Client; Rec.Client)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Client field.';
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field("Date Signed"; Rec."Date Signed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Signed field.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expiry Date field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contract Amount field.';
                }
            }
        }
    }

    actions { }
}

