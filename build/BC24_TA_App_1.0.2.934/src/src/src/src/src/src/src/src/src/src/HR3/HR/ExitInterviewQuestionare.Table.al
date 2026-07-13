table 50927 "Exit Interview Questionare"
{
    Caption = 'Exit Interview Questionare';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
            DataClassification = CustomerContent;
        }
        field(2; "Exit Interview Date"; Date)
        {
            Caption = 'Exit Interview Date';
            DataClassification = CustomerContent;
        }
        field(3; "Dissatisfaction with salary"; Boolean)
        {
            Caption = 'Dissatisfaction with salary';
        }
        field(4; "Dissatis with the type of work"; Boolean)
        {
            Caption = 'Dissatisfaction with the type of work';
        }
        field(5; "Dissatis with supervisor"; Boolean)
        {
            Caption = 'Dissatisfaction with supervisor';
        }
        field(6;"Dissatis with co-workers"; Boolean)
        {
            caption='Dissatisfaction with co-workers';
        }
        field(7;"Dissati with working condition";Boolean)
        {
            caption='Dissatisfaction with working condition';
        }

        field(8;"Dissatisfaction with benefits";Boolean)
        {
            caption='Dissatisfaction with benefits';
        }
        field(9;"Dissatis with assignment ";Boolean)
        {
            caption='Dissatisfaction with assignment ';
        }
        field(10;"Unable to be promoted";Boolean)
        {
            caption='Unable to be promoted';
        }
        field(11;"Family Problem";Boolean)
        {
            caption='Family Problem';
        }
        field(12;"Health problem";Boolean)
        {
            caption='Health problem';
        }
        field(13;"To further education";Boolean)
        {
            caption='To further education';
        }
        field(14;"To go abroad";Boolean)
        {
            caption='To go abroad';
        }
        field(15;"Retirement";Boolean)
        {
            caption='Retirement';
        }
        field(16;"Disciplinary Measure";Boolean)
        {
            caption='Disciplinary Measure';
        }
        field(17;Death;Boolean)
        {
            caption='Death';
        }
        field(18;Other;Boolean)
        {
            caption='Other';
        }
        field(19;"Reason for Other";Text[100])
        {
            caption='Reason for Other';
        }
        field(20;"what is the main reason?";Integer)
        {
            caption='If several, what is the main reason?';
        }
         field(21;"Answer number";Integer)
        {
            caption='Answer number';
        }
        field(22;"To join another company?";Boolean)
        {

        }
        field(23;"Which sector?";option)
        {
            OptionMembers=Banking,"NGO (local / International)",other;
        }
        field(24;"If other, specify secor";Text[50])
        {

        }
        field(25;"Attraction";Text[100])
        {
            Caption='Please indicate the major decision element or offer that attracted to join the new company/organization ';
        }
        field(26;"To start own business";Boolean){}
        field(27;"If other, Please indicated";Text[100])
        {
            
        }

        




    }
    keys
    {
        key(PK; "Employee Code","Exit Interview Date")
        {
            Clustered = true;
        }
    }
}
