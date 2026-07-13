page 50209 "Supply Chain Activities Cue"
{
    PageType = CardPart;
    SourceTable = "Supply Chain Activities Cue";
    ApplicationArea = All;

    layout
    {
        area(content)
        {

            cuegroup(SupplyChainActivities)
            {
                ShowCaption = false;
                field("Orders - Open"; Rec."Orders - Open")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Orders - Open field.';
                }

                field("Orders - Pending App"; Rec."Orders - Pending App")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Orders - Pending Approval field.';
                }

                field("Orders - Released"; Rec."Orders - Released")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Orders - Released field.';
                }
                field(Assigned; Rec.Assigned)
                {
                    Caption = 'Assigned Purchase Requisition';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assigned Purchase Requisition field.';
                }
                field(UnAssigned; Rec.UnAssigned)
                {
                    Caption = 'UnAssigned Purchase Requisition';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UnAssigned Purchase Requisition field.';
                }
            }
        }
    }

    trigger OnOpenPage();
    begin

        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;
    end;
}




