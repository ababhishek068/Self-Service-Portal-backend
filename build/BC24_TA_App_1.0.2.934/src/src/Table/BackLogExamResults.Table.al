Table 50274 "BackLog Exam Results"
{


    fields
    {
        field(1; "Reg No"; Code[20])
        {
            Editable = true;
            TableRelation = Customer;
        }
        field(2; "Unit Code"; Code[20]) { }
        field(3; Grade; Code[20])
        {
            Editable = false;
        }
        field(4; Description; Text[150]) { }
        field(5; "Ac Year"; Code[20]) { }
        field(6; CF; Decimal) { }
        field(7; "Year Score"; Decimal) { }
        field(8; Department; Text[50]) { }
        field(9; "Cum AVerage"; Decimal) { }
        field(10; Remark; Text[150]) { }
        field(11; Group; Code[50]) { }
        field(12; Programme; Code[20])
        {
            TableRelation = Programme.Code;
        }
        field(13; Entry; Integer) { }
        field(14; "Unit Score"; Decimal)
        {
            Editable = false;
        }
        field(15; Semester; Code[20]) { }
        field(16; "CF Score"; Decimal) { }
        field(17; "Total CF"; Decimal)
        {
            CalcFormula = sum("BackLog Exam Results".CF where("Reg No" = field("Reg No"),
                                                               Retaken = const(false),
                                                               Grade = filter(<> 'CT'),
                                                               "Ac Year" = field("Cumm Ac Year Filter")));
            FieldClass = FlowField;
        }
        field(18; "Total CF Score"; Decimal)
        {
            CalcFormula = sum("BackLog Exam Results"."CF Score" where("Reg No" = field("Reg No"),
                                                                       Retaken = const(false),
                                                                       Grade = filter(<> 'CT'),
                                                                       "Ac Year" = field("Cumm Ac Year Filter")));
            FieldClass = FlowField;
        }
        field(20; "Sem Total CF"; Decimal)
        {
            CalcFormula = sum("BackLog Exam Results".CF where("Reg No" = field("Reg No"),
                                                               "Ac Year" = field("Ac Year"),
                                                               Grade = filter(<> 'CT')));
            FieldClass = FlowField;
        }
        field(21; "Sem Total CF Score"; Decimal)
        {
            CalcFormula = sum("BackLog Exam Results"."CF Score" where("Reg No" = field("Reg No"),
                                                                       "Ac Year" = field("Ac Year"),
                                                                       Grade = filter(<> 'CT')));
            FieldClass = FlowField;
        }
        field(22; "Academic Year"; Code[20]) { }
        field(23; "Student Unit Count"; Integer)
        {
            CalcFormula = count("BackLog Exam Results" where("Reg No" = field("Reg No"),
                                                              "Unit Code" = field("Unit Code"),
                                                              Grade = filter(<> 'I')));
            FieldClass = FlowField;
        }
        field(24; Retaken; Boolean) { }
        field(25; "Cumm Ac Year Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(26; "Unit Stage"; Code[20])
        {
            CalcFormula = lookup("Units/Subjects"."Stage Code" where("Programme Code" = field(Programme),
                                                                      Code = field("Unit Code")));
            FieldClass = FlowField;
        }
        field(27; "Unit Count"; Integer)
        {
            CalcFormula = count("BackLog Exam Results" where("Reg No" = field("Reg No"),
                                                              "Unit Code" = field("Unit Code"),
                                                              Retaken = filter(false)));
            FieldClass = FlowField;
        }
        field(28; "Sys Rmk"; Text[30]) { }
        field(29; "Unit Score Count"; Integer)
        {
            CalcFormula = count("BackLog Exam Results" where("Reg No" = field("Reg No"),
                                                              "Unit Code" = field("Unit Code"),
                                                              Retaken = filter(false),
                                                              "Unit Score" = field("Unit Score")));
            FieldClass = FlowField;
        }
        field(30; Exempted; Boolean) { }
        field(31; "Programme Exam Category"; Code[20])
        {
            CalcFormula = lookup(Programme."Exam Category" where(Code = field(Programme)));
            FieldClass = FlowField;
        }
        field(32; "Results Count"; Integer)
        {
            CalcFormula = count("Exam Results" where("Student No." = field("Reg No"),
                                                      Unit = field("Unit Code")));
            FieldClass = FlowField;
        }
        field(33; "Grade Prefix"; Code[20]) { }
        field(34; Award; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(35; "Pass After Supp"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Reg No", "Unit Code", "Ac Year", Entry)
        {
            Clustered = true;
        }
        key(Key2; "Ac Year", Semester) { }
        key(Key3; "Ac Year") { }
        key(Key4; "Ac Year", Exempted) { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "Reg No" = '' then begin
            GLSetup.Get;
            GLSetup.TestField("Batch Receipts Nos");
            "Reg No":=NoSeriesMgt.GetNextNo(GLSetup."Batch Receipts Nos", 0D,true);
        end;
    end;

    var
        GLSetup: Record "General Set-Up";
        NoSeriesMgt: Codeunit "No. Series";
}

