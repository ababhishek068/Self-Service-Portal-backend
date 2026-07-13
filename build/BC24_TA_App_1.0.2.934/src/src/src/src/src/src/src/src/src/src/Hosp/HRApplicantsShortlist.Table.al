Table 50848 "HR Applicants Shortlist"
{

    fields
    {
        field(3; "Job Application No"; Code[20])
        {
            Editable = true;
            NotBlank = true;
            // TableRelation = Applicants."Application No" where("Job Applied For" = field("Job ID"));

            trigger OnValidate()
            begin
                // Applicants.Reset;
                // Applicants.SetRange(Applicants."Application No", "Job Application No");
                // if Applicants.Find('-') then begin
                //     "Applicant Name" := Applicants."First Name" + ' ' + Applicants."Middle Name" + ' ' + Applicants."Last Name";
                //     "Job ID" := Applicants."Job Applied For";
                //     "Job Applied for" := Applicants."Job Applied for Description";
                //     "ID No" := Applicants."ID Number";
                //     Gender := Applicants.Gender;
                // end;
            end;
        }
        field(4; "Stage Score"; Decimal)
        {
            Editable = false;
        }
        field(5; Qualified; Boolean) { }
        field(6; "Applicant Name"; Text[100])
        {
            Editable = false;
        }
        field(9; "ID No"; Text[100])
        {
            Editable = false;
        }
        field(10; Gender; Option)
        {
            Editable = false;
            OptionCaption = 'Male,Female';
            OptionMembers = Male,Female;
        }
        field(11; "Marital Status"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Single,Married,Separated,Divorced,Widow(er),Other';
            OptionMembers = " ",Single,Married,Separated,Divorced,"Widow(er)",Other;
        }
        field(12; "Manual Change"; Boolean)
        {
            Editable = false;
        }
        field(13; Employ; Boolean)
        {

            trigger OnValidate()
            begin
                /*
                IF Employ THEN BEGIN
                RNeeds.RESET;
                RNeeds.SETFILTER(RNeeds."Need Code","Need Code");
                IF RNeeds.FIND('-') THEN BEGIN
                IF RNeeds.Positions = 1 THEN BEGIN
                RNeeds."End Date":=TODAY;
                RNeeds.MODIFY;
                IF RNeeds."Start Date" <> 0D THEN BEGIN
                RNeeds."Turn Around Time":=RNeeds."End Date"-RNeeds."Start Date";
                RNeeds.MODIFY;
                END;
                END;
                IF RNeeds.Positions > 0 THEN BEGIN
                RNeeds.Positions:=RNeeds.Positions-1;
                RNeeds.MODIFY;
                END;
                END;
                Date:=TODAY;
                Applicants.RESET;
                Applicants.SETRANGE(Applicants."No.",Applicant);
                IF Applicants.FIND('-') THEN
                IF Applicants."Applicant Type"=Applicants."Applicant Type"::External THEN BEGIN;
                Employee."No.":=Applicants."No.";
                Employee."First Name":=Applicants."First Name";
                Employee."Middle Name":=Applicants."Middle Name";
                Employee."Last Name":=Applicants."Last Name";
                Employee.Initials:=Applicants.Initials;
                Employee."Search Name":=Applicants."Search Name";
                Employee."Postal Address":=Applicants."Postal Address";
                Employee."Residential Address":=Applicants."Residential Address";
                Employee.City:=Applicants.City;
                Employee."Post Code":=Applicants."Post Code";
                Employee.Region:=Applicants.Region;
                Employee."Home Phone Number":=Applicants."Home Phone Number";
                Employee."Cellular Phone Number":=Applicants."Cellular Phone Number";
                Employee."Work Phone Number":=Applicants."Work Phone Number";
                Employee."Ext.":=Applicants."Ext.";
                Employee."E-Mail":=Applicants."E-Mail";
                Employee."ID Number":=Applicants."ID Number";
                Employee.Gender:=Applicants.Gender;
                Employee."Country Code":=Applicants."Country Code";
                Employee."Fax Number":=Applicants."Fax Number";
                Employee."Marital Status":=Applicants."Marital Status";
                Employee."Ethnic Origin":=Applicants."Ethnic Origin";
                Employee."First Language (R/W/S)":=Applicants."First Language (R/W/S)";
                Employee."Driving Licence":=Applicants."Driving Licence";
                Employee.Disabled:=Applicants.Disabled;
                Employee."Health Assesment?":=Applicants."Health Assesment?";
                Employee."Health Assesment Date":=Applicants."Health Assesment Date";
                Employee."Date Of Birth":=Applicants."Date Of Birth";
                Employee.Age:=Applicants.Age;
                Employee."Second Language (R/W/S)":=Applicants."Second Language (R/W/S)";
                Employee."Additional Language":=Applicants."Additional Language";
                Employee."Postal Address2":=Applicants."Postal Address2";
                Employee."Postal Address3":=Applicants."Postal Address3";
                Employee."Residential Address2":=Applicants."Residential Address2";
                Employee."Residential Address3":=Applicants."Residential Address3";
                Employee."Post Code2":=Applicants."Post Code2";
                Employee.Citizenship:=Applicants.Citizenship;
                Employee."Passport Number":=Applicants."Passport Number";
                Employee."First Language Read":=Applicants."First Language Read";
                Employee."First Language Write":=Applicants."First Language Write";
                Employee."First Language Speak":=Applicants."First Language Speak";
                Employee."Second Language Read":=Applicants."Second Language Read";
                Employee."Second Language Write":=Applicants."Second Language Write";
                Employee."Second Language Speak":=Applicants."Second Language Speak";
                Employee."PIN Number":=Applicants."PIN Number";
                Employee.Position:=Applicants."Job Applied For";
                Employee."Country Code":=Applicants."Country Code";
                Employee.INSERT(TRUE);
                
                Applicants.Employ:=TRUE;
                Applicants.MODIFY;
                
                AppQualifications.RESET;
                AppQualifications.SETRANGE(AppQualifications."Employee No.",Applicant);
                IF AppQualifications.FIND('-') THEN BEGIN
                REPEAT
                EmpQualifications."Employee No.":=AppQualifications."Employee No.";
                EmpQualifications.Type:=AppQualifications."Qualification Type";
                EmpQualifications."Qualification Code":=AppQualifications."Qualification Code";
                EmpQualifications."From Date":=AppQualifications."From Date";
                EmpQualifications."To Date":=AppQualifications."To Date";
                EmpQualifications.Type:=AppQualifications.Type;
                EmpQualifications.Description:=AppQualifications.Description;
                EmpQualifications."Institution/Company":=AppQualifications."Institution/Company";
                EmpQualifications."Qualification Code":=AppQualifications.Qualification;
                EmpQualifications."Score ID":=AppQualifications."Score ID";
                EmpQualifications.Comment:=AppQualifications.Comment;
                EmpQualifications.INSERT;
                
                UNTIL AppQualifications.NEXT = 0
                END
                END
                ELSE BEGIN
                Employee.RESET;
                Employee.SETRANGE(Employee."No.",Applicants."Employee No");
                IF Employee.FIND('-') THEN BEGIN
                Employee.Position:=Applicants."Job Applied For";
                Employee.MODIFY;
                END
                END
                END
                  */

            end;
        }
        field(14; Date; Date) { }
        field(15; Position; Integer) { }
        field(16; "Reporting Date"; Date) { }
        field(17; "Shortlisting Officer"; Code[30])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(21; "Job Applied for"; Text[100]) { }
        field(22; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(23; Comments; Text[100]) { }
        field(24; "Job ID"; Code[20]) { }
        field(25; "Employee Requisition No"; Code[10]) { }
        field(26; "Shortlist Officer Count"; Integer)
        {
            CalcFormula = count("HR Applicants Shortlist" where("Job Application No" = field("Job Application No")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Line No", "Job Application No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        "Shortlisting Officer" := UserId;
        // "Job ID":=

        /*HRSL.RESET;
        //HRSL.SETRANGE(HRSL."Shortlist 1",userid);
        HRSL.SETRANGE(HRSL."Job Application No","Job Application No");
        IF HRSL.FIND('-') THEN BEGIN
           ERROR('Dear user, you have already shortlisted this candidate %1. with Job Application No. %2',"Applicant Name","Job Application No");
        END ELSE BEGIN
        END;
        USER.RESET;
        //HRSL.SETRANGE(HRSL."Shortlist 1",userid);
        USER.SETRANGE(USER."User ID","Shortlisting Officer");
        IF USER.FIND('-') THEN BEGIN
           ERROR('Dear user, you have already shortlisted this candidate %1. with Job Application No. %2',"Applicant Name","Job Application No");
        END ELSE BEGIN
        END;
        */

    end;
}

