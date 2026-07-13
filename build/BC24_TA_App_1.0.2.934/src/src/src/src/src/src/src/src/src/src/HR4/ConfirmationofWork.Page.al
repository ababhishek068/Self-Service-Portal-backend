Page 51245 "Confirmation of Work"
{
    PageType = List;
    SourceTable = "Confirmation of Work";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(GatePassNo; Rec."Gate Pass No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Gate Pass No. field.';
                }
                field(DateOfConfirmation; Rec."Date Of Confirmation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Of Confirmation field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(EmployeeNo; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
                field(EmployeeName; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field(NameofAsset; Rec."Name of Asset")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name of Asset field.';
                }
                field(TypeofWorkDone; Rec."Type of Work Done")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type of Work Done field.';
                }
                field(ServiceProvider; Rec."Service Provider")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Service Provider field.';
                }
                field(ServiceProviderComments; Rec."Service Provider Comments")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Service Provider Comments field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(AdminComment; Rec."Admin Comment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admin Comment field.';
                }
            }
        }
    }

    actions { }
}

