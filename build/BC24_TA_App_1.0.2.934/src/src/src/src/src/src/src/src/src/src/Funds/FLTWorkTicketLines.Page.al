Page 50639 "FLT Work Ticket Lines"
{
    PageType = ListPart;
    SourceTable = "FLT-Daily Work Ticket Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DriverNo; Rec."Driver No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver No. field.';
                }
                field(DriverName; Rec."Driver Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver Name field.';
                }
                field(DepartureFrom; Rec."Departure From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Departure From field.';
                }
                field(Destination; Rec.Destination)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destination field.';
                }
                field(WorkDate; Rec."Work Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Work Date field.';
                }
                field(AuthorizingOfficerNo; Rec."Authorizing Officer No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Authorizing Officer No field.';
                }
                field(AuthorizingOfficerName; Rec."Authorizing Officer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Authorizing Officer Name field.';
                }
                field(TimeOut; Rec."Time Out")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Out field.';
                }
                field(TimeIn; Rec."Time In")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time In field.';
                }
                field(StartMilleage; Rec."Start Milleage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Milleage field.';
                }
                field(EndMilleage; Rec."End Milleage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Milleage field.';
                }
                field(RegNo; Rec."Reg. No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reg. No. field.';
                }
                field(VoucherNo; Rec."Voucher No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Voucher No. field.';
                }
            }
        }
    }

    actions { }
}

