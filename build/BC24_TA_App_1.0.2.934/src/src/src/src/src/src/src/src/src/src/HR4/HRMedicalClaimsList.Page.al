Page 51341 "HR Medical Claims List"
{
    // CardPageID = hr medica;
    PageType = List;
    SourceTable = "HR Medical Claims";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(MemberNo; Rec."Member No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Member No field.';
                }
                field(ClaimNo; Rec."Claim No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Claim No field.';
                }
                field(ClaimType; Rec."Claim Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Claim Type field.';
                }
                field(ClaimDate; Rec."Claim Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Claim Date field.';
                }
                field(PatientName; Rec."Patient Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient Name field.';
                }
                field(DateofService; Rec."Date of Service")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Service field.';
                }
                field(AmountCharged; Rec."Amount Charged")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount Charged field.';
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        if userSetUp.Get(UserId) then begin
            //if userSetUp."Medical Team"=false then
            // Error('You do not have permission to access this page!!!');
        end;
    end;

    var
        userSetUp: Record "User Setup";
}

