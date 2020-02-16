package su.boleyn.oj.judge;

import java.io.IOException;

public class Main {

	public static void main(String[] args) throws InterruptedException, IOException {
		if (args.length == 1 && args[0].equals("judge")) {
			System.out.println("running the judge");
			Judge.main(args);
		} else if (args.length == 1 && args[0].equals("runner")) {
			System.out.println("running the runner");
			C99Runner.main(args);
		} else if (args.length == 1 && args[0].equals("both")) {
			System.out.println("running the judge and the runner");
			System.out.println("WARNING:");
			System.out.println("We DO NOT recommand running judge and runner together due to security reasons.");
			System.out.println(
					"The runner should be in a very restricted enviroment since we are running untrusted code in it.");
			System.out.println("This option should only be used in the devlopment enviroment.");
			Thread fork = new Thread() {
				public void run() {
					try {
						C99Runner.main(args);
					} catch (IOException | InterruptedException e) {
					}
				}
			};
			fork.start();
			Judge.main(args);
			fork.join();
		} else {
			System.out.println("supported command line arguments:");
			System.out.println("judge");
			System.out.println("runner");
			System.out.println("both");
		}
	}
}
