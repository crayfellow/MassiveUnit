package massive.munit.async;

import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

/**
 * Collection of use cases for async test assertions used by TestRunnerTest
 * to validate that syncronous assertions/exceptions are handled correctly.
 */

class AsyncTestClassStub
{
	static public var handlerCount:Int = 0;
	public function new() 
	{}
	
	@BeforeClass
	public function beforeClass():Void
	{
		handlerCount = 0;
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function before():Void
	{
	}
	
	@After
	public function after():Void
	{
	}

	@AsyncTest
	public function shouldAssertAsync(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, asyncHandler, 100);
		Timer.delay(handler, 50);
	}

	@AsyncTest
	public function shouldAsyncTimeout(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, asyncHandler, 50);
		Timer.delay(handler, 100);
	}

	@AsyncTest
	public function shouldAllowSyncAssertInsideAsyncTest(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, asyncHandler, 100);
		Assert.isTrue(true);
		Timer.delay(handler, 50);
	}

	@AsyncTest
	public function shouldCancelAsyncIfExceptionThrown(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, asyncHandler, 100);
		Timer.delay(handler, 50);
		throw "exception in async test";
	}

	@AsyncTest
	public function shouldCancelAsyncIfSyncAssertFailsAfterHandlerCreated(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, asyncHandler, 100);
		Assert.fail("failed assert in async test");
		Timer.delay(handler, 50);
	}

	@AsyncTest
	public function shouldCancelAsyncIfSyncAssertFailsAfterTimerCreated(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, asyncHandler, 100);
		Timer.delay(handler, 50);
		Assert.fail("failed assert in async test");
	}

	@AsyncTest
	public function shouldCancelAsyncIfSyncAssertFailsBeforeHandlerCreated(factory:AsyncFactory):Void
	{
		Assert.fail("failed assert in async test");
		var handler:Dynamic = factory.createHandler(this, asyncHandler, 100);
		Timer.delay(handler, 50);
		
	}


	//------------------
	private function asyncHandler():Void
	{
		handlerCount ++;
		Assert.isTrue(true);
	}
}

/**
 * Secondary class used to verify that no wayward async assertions trigger
 * after the main AsyncTestClassStub tests (or possibly after all other tests have finished).
 */
class AsyncTestClassStub2
{
	public function new()
	{
		
	}

	@AsyncTest
	public function shouldAssertAsync(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, asyncHandler, 2500);
		Timer.delay(handler, 2000);
	}

	private function asyncHandler():Void
	{
		Assert.isTrue(AsyncTestClassStub.handlerCount == 2);
	}
}
