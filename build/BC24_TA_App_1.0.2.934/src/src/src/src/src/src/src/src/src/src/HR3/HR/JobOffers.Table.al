table 51016 "Job Offers"
{
    Caption = 'Job Offers';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Job Offer Code"; Code[20])
        {
            Caption = 'Job Offer Code';
        }
        field(2; Interviwee; Code[20])
        {
            Caption = 'Interviwee';
        }
        field(3; "Interview Code"; Code[20])
        {
            Caption = 'Interview Code';
            TableRelation="HR Job Interview"."Interview Code";
        }
        field(4; Interview; Date)
        {
            Caption = 'Interview';
        }
    }
    keys
    {
        key(PK; "Job Offer Code")
        {
            Clustered = true;
        }
    }
}
