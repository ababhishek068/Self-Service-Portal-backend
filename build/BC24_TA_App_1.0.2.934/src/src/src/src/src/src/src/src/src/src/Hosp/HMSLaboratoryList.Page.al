Page 50826 "HMS Laboratory List"
{
    CardPageID = "HMS Laboratory Form Test";
    PageType = List;
    SourceTable = "HMS Laboratory Form Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field(LaboratoryNo; Rec."Laboratory No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(LinkType; Rec."Link Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Link Type field.';
                }
                field(LinkNo; Rec."Link No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Link No. field.';
                }
                field(LaboratoryDate; Rec."Laboratory Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Laboratory Date field.';
                }
                field(LaboratoryTime; Rec."Laboratory Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Laboratory Time field.';
                }
                field(PatientNo; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(ADMNo; Rec."ADM No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ADM No. field.';
                }
                field(MemeberNo; Rec."Memeber No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Memeber No field.';
                }
                field(Surname; Rec.Surname)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Surname field.';
                }
                field(MiddleName; Rec."Middle Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Middle Name field.';
                }
                field(LastName; Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(ScheduledDate; Rec."Scheduled Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Scheduled Date field.';
                }
                field(ScheduledTime; Rec."Scheduled Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Scheduled Time field.';
                }
                field(SupervisorID; Rec."Supervisor ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supervisor ID field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions { }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

