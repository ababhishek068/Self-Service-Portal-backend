Page 50844 "HMS Immunization Posted List"
{
    CardPageID = "HMS Immunization Posted";
    Editable = false;
    PageType = List;
    SourceTable = "HMS Immunization";
    SourceTableView = where(Posted = const(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Select; Rec.Select)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Select field.';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(ImmunizationDate; Rec."Immunization Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Immunization Date field.';
                }
                field(ImmunizationTime; Rec."Immunization Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Immunization Time field.';
                }
                field(PatientType; Rec."Patient Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient Type field.';
                }
                field(PatientNo; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient No. field.';

                    trigger OnValidate()
                    begin
                        Patient.Reset;
                        if Patient.Get(Rec."Patient No.") then begin
                            Rec."Patient Name" := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
                        end;
                    end;
                }
                field(PatientName; Rec."Patient Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient Name field.';
                }

                field(Given; Rec.Given)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Given field.';
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

    var
        Patient: Record "HMS Patient";
}

