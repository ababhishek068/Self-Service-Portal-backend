#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50994 "Decommisioned ATMs"
{

    fields
    {
        field(2;"Serial No";Code[40])
        {
        }
        field(3;Name;Text[50])
        {
        }
        field(4;Location;Text[30])
        {
        }
        field(5;"Location Type";Option)
        {
            OptionCaption = ',Lobby,Branch';
            OptionMembers = ,Lobby,Branch;
        }
        field(6;Model;Code[30])
        {
        }
        field(7;Done;Boolean)
        {
        }
        field(8;counter;Code[10])
        {
        }
        field(9;"ATM NO";Code[10])
        {
            TableRelation = "ATM Register."."ATM No";
        }
    }

    keys
    {
        key(Key1;"Serial No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

