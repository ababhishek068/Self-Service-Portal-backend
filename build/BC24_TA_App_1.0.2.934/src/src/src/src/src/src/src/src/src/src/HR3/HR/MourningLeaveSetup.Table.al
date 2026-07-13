table 51020 "Mourning Leave Setup"
{
    Caption = 'Mourning Leave Setup';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Family Member"; Option)
        {
            Caption = 'Family Member';
            OptionMembers=" ",Aunt,Brother,Child,Father,"Father-in-law","Grand-Parents",Mother,"Mother-in-Law",Sister,"Step-Dad","Step-Mom",Inlaw,Uncle;
        }
        field(2; "No of Days";Integer )
        {
            Caption = 'No of Days';
            MinValue=1;
        }
    }
    keys
    {
        key(PK; "Family Member")
        {
            Clustered = true;
        }
    }
}
