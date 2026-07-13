page 51015 "Chemical Usage Register"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Items Usage Register";
    SourceTableView = where(Type = const(Chemicals));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("SRN No"; Rec."SRN No")
                {

                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SRN No field.';


                }
                field("Item No"; Rec."Item No")
                {

                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity Received field.';

                }
                field("Quantity Used"; Rec."Quantity Used")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity Used field.';

                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Balance field.';

                }
            }
        }
    }


    actions
    {
        area(Reporting)
        {
            action(WaterBillReg)
            {
                Caption = 'Material Usage Report';
                ApplicationArea = All;
                RunObject = report "Material Usage";
                ToolTip = 'Executes the Material Usage Report action.';
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.type::Chemicals;
    end;
}