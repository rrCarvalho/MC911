class a
{
	public static void main(String[] args)
	{{
		System.out.println(new b().m());
		System.out.println(new b().n(45));
		System.out.println(new b().dd());
	}}
}

class b
{
	public int m()
	{
		int c;
		
		c = 1;
		
		return 1+2;
	}
	
	public int n(int f)
	{
		return f;
	}
	
	public int dd()
	{
		return 99;
	}


}