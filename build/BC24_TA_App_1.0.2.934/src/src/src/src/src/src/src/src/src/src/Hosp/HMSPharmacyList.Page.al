Page 51423 "HMS Pharmacy List"
{
    CardPageID = "HMS Pharmacy Header";
    PageType = List;
    SourceTable = "HMS Pharmacy Header";
    SourceTableView = where(Status = filter(New));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field(PharmacyNo; Rec."Pharmacy No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pharmacy No. field.';
                }
                field(PharmacyDate; Rec."Pharmacy Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pharmacy Date field.';
                }
                field(PharmacyTime; Rec."Pharmacy Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pharmacy Time field.';
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
                field(PatientNo; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field(ADMNo; Rec."ADM No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ADM No field.';
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
                field(IssuedBy; Rec."Issued By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Issued By field.';
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
                field(InsuranceNo; Rec."Insurance No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Insurance No field.';
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

