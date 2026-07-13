page 50972 "Fuel Recharge Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "FLT-Fuel & Maintenance Req.";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Requisition No"; Rec."Requisition No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requisition No field.';
                }
                field(Driver; Rec.Driver)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Driver field.';
                }
                field("Driver Name"; Rec."Driver Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Driver Name field.';
                }
                field("Vehicle Reg No"; Rec."Vehicle Reg No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle Reg No field.';
                }
                field("Max. Amount Allocated"; Rec."Max. Amount Allocated")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max. Amount Allocated field.';
                }
                field("Amount Consumed"; Rec."Amount Consumed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount Consumed field.';
                }
                field("Amount To be Toped Up"; Rec."Amount To be Toped Up")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount To be Toped Up field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
        area(Factboxes) { }
    }

    actions { }
}