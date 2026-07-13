Page 51340 "HR Medical Scheme Members List"
{
    CardPageID = "HR Medical Scheme Members Card";
    PageType = List;
    SourceTable = "HR Medical Scheme Members";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmployeeNo; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
                field(FirstName; Rec."First Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field(LastName; Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Member No field.';
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Designation field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(SchemeJoinDate; Rec."Scheme Join Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Scheme Join Date field.';
                }
                field(CummAmountSpent; Rec."Cumm.Amount Spent")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cumm.Amount Spent field.';
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        if UserSetUp.Get(UserId) then begin
            if UserSetUp."Medical Team" = false then
                Error('You do not have permission to access this page!!!');
        end;
    end;

    var
        UserSetUp: Record "User Setup";
}

