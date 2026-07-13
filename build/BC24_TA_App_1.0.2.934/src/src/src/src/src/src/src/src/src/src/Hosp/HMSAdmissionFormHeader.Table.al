Table 50767 "HMS Admission Form Header"
{
    //  LookupPageID = "WF Designation List";

    fields
    {
        field(1; "Admission No."; Code[20]) { }
        field(2; "Admission Date"; Date)
        {
            NotBlank = true;
        }
        field(3; "Admission Time"; Time)
        {
            NotBlank = true;
        }
        field(4; "Admission Area"; Option)
        {
            OptionMembers = Doctor,Referral;
        }
        field(5; "Patient No."; Code[20])
        {
            NotBlank = true;
        }
        field(6; "Employee No."; Code[20])
        {
            NotBlank = false;
        }
        field(7; "Relative No."; Integer) { }
        field(8; Ward; Code[20])
        {
            TableRelation = "HMS Ward Setup"."Ward Code";
        }
        field(9; Bed; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Beds"."Bed No" where("Ward No" = field(Ward),
                                                       Occupied = filter(false));

            trigger OnValidate()
            begin
                if (xRec.Bed <> '') and (Bed <> '') then begin
                    if xRec.Bed <> Bed then begin
                        if Confirm('Do you want change the patient Bed Number?', false) then begin
                            HMSPatCharges.Reset;
                            HMSPatCharges.SetRange(HMSPatCharges."Patient No.", "Patient No.");
                            HMSPatCharges.SetRange(HMSPatCharges."Transaction Type", 'BED CHARGES');
                            HMSPatCharges.SetRange(HMSPatCharges.Date, Today);
                            if HMSPatCharges.Find('-') then begin
                                HMSPatCharges.Code := Bed;
                                HMSPatCharges.Modify;
                            end;
                        end;
                    end;
                end;
            end;
        }
        field(10; Doctor; Code[20])
        {
            NotBlank = true;
        }
        field(11; Remarks; Text[200]) { }
        field(12; Status; Option)
        {
            OptionMembers = New,Admitted,Discharged,Cancelled,"Discharge Pending";
        }
        field(13; "No. Series"; Code[20]) { }
        field(14; "Student No."; Code[20]) { }
        field(15; "Link Type"; Code[20]) { }
        field(16; "Link No."; Code[20]) { }
        field(17; "Admission Reason"; Text[200]) { }
        field(27; Surname; Text[100])
        {
            CalcFormula = lookup("HMS Patient".Surname where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(28; "Middle Name"; Text[30])
        {
            CalcFormula = lookup("HMS Patient"."Middle Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(29; "Last Name"; Text[50])
        {
            CalcFormula = lookup("HMS Patient"."Last Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(30; "ID Number"; Code[20])
        {
            CalcFormula = lookup("HMS Patient"."ID Number" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(31; "Correspondence Address 1"; Text[100])
        {
            CalcFormula = lookup("HMS Patient"."Correspondence Address 1" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(32; "Telephone No. 1"; Code[100])
        {
            CalcFormula = lookup("HMS Patient"."Telephone No. 1" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(33; Email; Text[100])
        {
            CalcFormula = lookup("HMS Patient".Email where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(34; "Patient Ref. No."; Code[20])
        {
            CalcFormula = lookup("HMS Patient"."Patient Ref. No." where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(35; "Nurse Notes"; Text[200]) { }
        field(36; NHIF; Boolean) { }
        field(37; "Search Name"; Text[200]) { }
        field(38; Scheme; Option)
        {
            CalcFormula = lookup("HMS Patient"."Patient Type" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
            OptionCaption = ' ,Corporate,Cash';
            OptionMembers = " ",Corporate,Cash;
        }
        field(39; "Current Bill"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges"."Total Amount" where("Patient No." = field("Patient No."),
                                                                          "Total Amount" = filter(> 0),
                                                                          Posted = const(false),
                                                                          Closed = const(false)));
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;
        }
        field(40; Receipts; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges".Amount where("Patient No." = field("Patient No."),
                                                                  Amount = filter(< 0),
                                                                  Closed = const(false)));
            FieldClass = FlowField;
        }
        field(41; Balance; Decimal)
        {
            FieldClass = Normal;
        }
        field(42; "Admission Type"; Option)
        {
            OptionCaption = ' ,Medical,Surgical,ICU,Day Case';
            OptionMembers = " ",Medical,Surgical,ICU,"Day Case";
        }
        field(43; "Admission Height"; Decimal) { }
        field(44; "Admission Weight"; Decimal) { }
        field(45; "Admission BMI"; Decimal) { }
        field(46; Nutrition; Boolean) { }
        field(47; "Nutrition Status"; Option)
        {
            OptionCaption = ',Sent,Stopped,Start,Aborted,On hold';
            OptionMembers = ,Sent,Stopped,Start,Aborted,"On hold";
        }
        field(48; Counselling; Boolean) { }
        field(49; "Counselling Status"; Option)
        {
            OptionCaption = ',Sent,Stopped,Start,Aborted,On hold';
            OptionMembers = ,Sent,Stopped,Start,Aborted,"On hold";
        }
        field(50; Branch; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BRANCH'));
        }
    }

    keys
    {
        key(Key1; "Admission No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        HMSPatCharges: Record "HMS Patient Charges";
}

