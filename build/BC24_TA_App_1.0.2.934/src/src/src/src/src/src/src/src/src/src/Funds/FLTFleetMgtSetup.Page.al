Page 51364 "FLT Fleet Mgt Setup"
{
    CardPageID = "FLT Fleet Mgt Setup Card";
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "FLT-Fleet Mgt Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TransportReqNo; Rec."Transport Req No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transport Req No field.';
                }
                field(DailyWorkTicket; Rec."Daily Work Ticket")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Daily Work Ticket field.';
                }
                field(FuelRegister; Rec."Fuel Register")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fuel Register field.';
                }
                field(MaintenanceRequest; Rec."Maintenance Request")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Maintenance Request field.';
                }
                field(RotationInterval; Rec."Rotation Interval")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Rotation Interval field.';
                }
                field(FuelPaymentBatchNo; Rec."Fuel Payment Batch No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fuel Payment Batch No field.';
                }
                field("Notification Email"; Rec."Notification Email")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notification Email field.';
                }
            }
        }
    }

    actions { }
}

