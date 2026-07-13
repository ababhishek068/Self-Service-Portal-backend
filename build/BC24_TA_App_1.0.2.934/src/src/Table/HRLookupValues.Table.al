Table 50793 "HR Lookup Values"
{
    DrillDownPageID = "HR Lookup Values List";
    LookupPageID = "HR Lookup Values List";

    fields
    {
        field(1; Type; Option)
        {

            OptionMembers = Religion,Language,"Medical Scheme",Location,"Contract Type","Qualification Type",Stages,Scores,Institution,"Appraisal Type","Appraisal Period",Urgency,Succession,Security,"Disciplinary Case Rating","Disciplinary Case","Disciplinary Action","Next of Kin",Region,Grade,"Checklist Item","Appraisal Sub Category","Appraisal Group Item","Transport Type","Training Cost Items","Training Category",Dependant,CompetenceValues,"ShortListing Criteria","Qualification category","Sub Tribe",Appointments,"Job Cader","Previous Payment System","Ethnicity","Nationality","Appraisal Perspective",Course,"PSC Grade","Disability Type";
            // OptionMembers = Religion,Language,"Medical Scheme",Location,"Contract Type","Qualification Type",Stages,Scores,Institution,"Appraisal Type","Appraisal Period",Urgency,Succession,Security,"Disciplinary Case Rating","Disciplinary Case","Disciplinary Action","Next of Kin",Region,Grade,"Checklist Item","Appraisal Sub Category","Appraisal Group Item","Transport Type","Training Cost Items","Training Category",Dependant,CompetenceValues,"ShortListing Criteria","Qualification category","Sub Tribe",Appointments,"Job Cader","Previous Payment System","Ethnicity","Nationality","Appraisal Perspective";
        }
        field(2; "Code"; Code[70])
        {
            /* trigger OnValidate()
            begin
                if Type = Type::"Qualification Type" then
                    category := code;
                if Type = Type::"Qualification category" then
                    "Sub Category" := code;
            end; */
        }
        field(3; Description; Text[50]) { }
        field(4; Remarks; Text[250]) { }
        field(5; "Notice Period"; Date) { }
        field(6; Closed; Boolean) { }
        field(7; "Contract Length"; Integer) { }
        field(8; "Current Appraisal Period"; Boolean) { }
        field(9; "Disciplinary Case Rating"; Text[30])
        {
            TableRelation = "HR Lookup Values".Code where(Type = const("Disciplinary Case Rating"));
        }
        field(10; "Disciplinary Action"; Code[20])
        {
            TableRelation = "HR Lookup Values".Code where(Type = const("Disciplinary Action"));
        }
        field(14; From; Date) { }
        field(15; "To"; Date) { }
        field(16; Score; Decimal) { }
        field(17; "Basic Salary"; Decimal) { }
        field(18; "To be cleared by"; Code[20])
        {
            TableRelation = "HR Jobs"."Job ID";
        }
        field(50000; "Weight Scores"; Decimal) { }
        field(50001; "Job Scale"; Code[20]) { }
        field(50002; "Next Period"; Boolean) { }
        field(50003; "Previous Job Position"; Boolean) { }
        field(50004; "Previous Job Position Order"; Integer) { }
        field(50005; "Category"; Code[70]) { }
        field(50006; "Sub Category"; Code[70]) { }
        field(50007; "Qualification Type"; Option)
        {
            OptionMembers = ,Academics,Experience,Publications,Interview;
        }
        field(59; "Employee Type"; Option)
        {
            OptionCaption = ' ,Permanent,Casual,Part Time,Interns,Contract,UnPaidLeave,Seconded';
            OptionMembers = " ",Permanent,Casual,"Part Time",Interns,Contract,UnPaidLeave,Seconded;
        }

    }

    keys
    {
        key(Key1; Type, "Code", Category, "Sub Category")
        {
            Clustered = true;
        }



    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description) { }
    }
}

