Table 50400 "Project Study areas new"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Inv. code"; Code[10]) { }
        field(3; "Area of Focus"; Option)
        {
            OptionCaption = ' ,Adult Medicine,Basic Science,Behavioural & Social Science,Bioethics,Cardiovascular & Metabolic Disease,Informatics,Laboratory,Nutrition,Oncology,Pharmacy,PMTCT,Public Health & Primary Care,Reproductive Health,Tuberculosis,Other';
            OptionMembers = " ","Adult Medicine","Basic Science","Behavioural & Social Science",Bioethics,"Cardiovascular & Metabolic Disease",Informatics,Laboratory,Nutrition,Oncology,Pharmacy,PMTCT,"Public Health & Primary Care","Reproductive Health",Tuberculosis,Other;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Inv. code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

